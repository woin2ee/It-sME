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
        let loggedInAndNeedSignUp: Signal<Bool>
    }
    
    let saveAppleIDRefreshTokenToKeychainUseCase: SaveAppleIDRefreshTokenToKeychainUseCase = .init()
    
    let userRepository: UserRepository = .shared
    
    func transform(input: Input) -> Output {
        let loggedInWithKakao = input.kakaoLoginRequest
            .flatMapFirst {
                return self.loginWithKakao()
                    .asSignalOnErrorJustComplete()
            }
        
        let loggedInWithApple = input.appleLoginRequest
            .flatMapFirst {
                return self.loginWithApple()
                    .asSignalOnErrorJustComplete()
            }
        
        let loggedInAndNeedSignUp = Signal.merge(loggedInWithKakao, loggedInWithApple)
            .flatMapFirst { _ in
                return self.userRepository.hasUserInfo
                    .asSignalOnErrorJustComplete()
            }
            .doOnNext { hasUserInfo in
                ItsMEUserDefaults.allowsAutoLogin = hasUserInfo
            }
            .map { !$0 } // 유저 정보가 존재하면 SignUp 불필요.
        
        return .init(loggedInAndNeedSignUp: loggedInAndNeedSignUp)
    }
}

// MARK: - Private Functions

private extension LoginViewModel {
    
    func loginWithApple() -> Single<Void> {
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
                
                let authorizationCode: String = try {
                    let codeData = try unwrapOrThrow(appleIDCredential.authorizationCode)
                    return try unwrapOrThrow(String(data: codeData, encoding: .utf8))
                }()
                
                let signInToFirebase = self.signInToFirebase(withIDToken: idTokenString, providerID: .apple, rawNonce: rawNonce)
                let saveAppleIDRefreshToken = self.saveAppleIDRefreshTokenToKeychainUseCase.rx.execute(authorizationCode: authorizationCode)
                
                return signInToFirebase.flatMap { _ in
                    return saveAppleIDRefreshToken
                }
            }
    }
    
    func loginWithKakao() -> Observable<Void> {
        let rawNonce = randomNonceString()
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk(nonce: sha256(rawNonce))
                .map(\.idToken)
                .unwrapOrThrow()
                .flatMapFirst { idToken in
                    self.signInToFirebase(withIDToken: idToken, providerID: .kakao, rawNonce: rawNonce).asObservable()
                }
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount(nonce: sha256(rawNonce))
                .map(\.idToken)
                .unwrapOrThrow()
                .flatMapFirst { idToken in
                    self.signInToFirebase(withIDToken: idToken, providerID: .kakao, rawNonce: rawNonce).asObservable()
                }
        }
    }
    
    func signInToFirebase(withIDToken idToken: String, providerID: AuthProviderID, rawNonce: String) -> Single<Void> {
        let credential = OAuthProvider.credential(
            withProviderID: providerID.rawValue,
            idToken: idToken,
            rawNonce: rawNonce
        )
        
        return Auth.auth().rx.signIn(with: credential)
            .mapToVoid()
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
