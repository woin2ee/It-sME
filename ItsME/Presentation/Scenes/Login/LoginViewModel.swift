//
//  LoginViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/15.
//

import AuthenticationServices
import FirebaseAuth
import RxSwift
import RxCocoa
import RxKakaoSDKUser
import KakaoSDKAuth
import KakaoSDKUser

final class LoginViewModel: ViewModelType {
    
    struct Input {
        let kakaoLoginRequest: Signal<Void>
        let appleLoginRequest: Signal<Void>
    }
    
    struct Output {
        let loggedIn: Signal<Void>
        let needSignUp: Signal<Void>
    }
    
    func transform(input: Input) -> Output {
        let authDataResultForKakaoLogin = input.kakaoLoginRequest.asObservable()
            .flatMapFirst {
                return self.loginWithKakao()
            }
        
        let authDataResultForAppleLogin = input.appleLoginRequest.asObservable()
            .flatMapFirst {
                return self.loginWithApple()
            }
        
        let authDataResult = Observable.merge(authDataResultForKakaoLogin, authDataResultForAppleLogin)
        
        let isNewUser = authDataResult
            .map { authDataResult in
                guard let isNewUser = authDataResult.additionalUserInfo?.isNewUser else {
                    throw LoginViewModelError.LoginFailed
                }
                return isNewUser
            }
        
        let loggedIn = isNewUser
            .filter { $0 == false }
            .mapToVoid()
            .asSignalOnErrorJustComplete()
        
        let needSignUp = isNewUser
            .filter { $0 == true }
            .mapToVoid()
            .asSignalOnErrorJustComplete()
        
        return .init(
            loggedIn: loggedIn,
            needSignUp: needSignUp
        )
    }
}

// MARK: - Private Functions

private extension LoginViewModel {
    
    func loginWithApple() -> Single<AuthDataResult> {
        let rawNonce = randomNonceString()
        
        let appleIDProvider = ASAuthorizationAppleIDProvider.init()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(rawNonce)
        
        let authorizationController = ASAuthorizationController.init(authorizationRequests: [request])
        authorizationController.performRequests()
        
        return authorizationController.rx.didCompleteWithAuthorization
            .asSingle()
            .flatMap { authorization in
                guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                      let idTokenData = appleIDCredential.identityToken,
                      let idTokenString = String(data: idTokenData, encoding: .utf8)
                else {
                    throw ASAuthorizationError(.failed)
                }
                
                ItsMEUserDefaults.isLoggedInAsApple = true
                ItsMEUserDefaults.setAppleUserID(appleIDCredential.user)
                
                let credential = OAuthProvider.credential(
                    withProviderID: "apple.com",
                    idToken: idTokenString,
                    rawNonce: rawNonce
                )
                
                return Auth.auth().rx.signIn(with: credential)
            }
    }
    
    func loginWithKakao() -> Observable<AuthDataResult> {
        let rawNonce = randomNonceString()
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk(nonce: sha256(rawNonce))
                .flatMapFirst { oAuthToken in
                    self.signInToFirebase(with: oAuthToken, rawNonce: rawNonce).asObservable()
                }
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount(nonce: sha256(rawNonce))
                .flatMapFirst { oAuthToken in
                    self.signInToFirebase(with: oAuthToken, rawNonce: rawNonce).asObservable()
                }
        }
    }
    
    func signInToFirebase(with oAuthToken: OAuthToken, rawNonce: String) -> Single<AuthDataResult> {
        guard let idToken = oAuthToken.idToken else {
            return .error(LoginViewModelError.LoginFailed)
        }
        
        let providerID = "oidc.kakao" // Firebase console: Authentication 탭에서 설정한 OIDC 제공업체 ID
        let credential = OAuthProvider.credential(
            withProviderID: providerID,
            idToken: idToken,
            rawNonce: rawNonce
        )
        
        return Auth.auth().rx.signIn(with: credential)
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension LoginViewModel {
    
    enum LoginViewModelError: Error {
        case LoginFailed
    }
}
