//
//  LoginViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/15.
//

import AuthenticationServices
import ItsMEUtil
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    // MARK: UseCases
    
    let saveAppleIDRefreshTokenToKeychainUseCase: SaveAppleIDRefreshTokenToKeychainUseCaseProtocol
    let loginWithAppleUseCase: LoginWithAppleUseCaseProtocol
    let loginWithKakaoUseCase: LoginWithKakaoUseCaseProtocol
    let signInToFirebaseUseCase: SignInToFirebaseUseCaseProtocol
    let getNicknameAndEmailForKakaoUseCase: GetNicknameAndEmailForKakaoUseCaseProtocol
    
    let userRepository: UserProfileRepositoryProtocol
    
    init(
        saveAppleIDRefreshTokenToKeychainUseCase: SaveAppleIDRefreshTokenToKeychainUseCaseProtocol,
        loginWithAppleUseCase: LoginWithAppleUseCaseProtocol,
        loginWithKakaoUseCase: LoginWithKakaoUseCaseProtocol,
        signInToFirebaseUseCase: SignInToFirebaseUseCaseProtocol,
        getNicknameAndEmailForKakaoUseCase: GetNicknameAndEmailForKakaoUseCaseProtocol,
        userRepository: UserProfileRepositoryProtocol
    ) {
        self.saveAppleIDRefreshTokenToKeychainUseCase = saveAppleIDRefreshTokenToKeychainUseCase
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.loginWithKakaoUseCase = loginWithKakaoUseCase
        self.signInToFirebaseUseCase = signInToFirebaseUseCase
        self.getNicknameAndEmailForKakaoUseCase = getNicknameAndEmailForKakaoUseCase
        self.userRepository = userRepository
    }
    
    func transform(input: Input) -> Output {
        let loggedInWithKakao = input.kakaoLoginRequest
            .flatMapFirst {
                let rawNonce = randomNonceString()
                return self.loginWithKakaoUseCase.execute(withRawNonce: rawNonce)
                    .map(\.idToken)
                    .unwrapOrThrow()
                    .flatMap { idToken in
                        self.signInToFirebaseUseCase.execute(withIDToken: idToken, providerID: .kakao, rawNonce: rawNonce)
                    }
                    .flatMap { _ in self.getNicknameAndEmailForKakaoUseCase.execute() }
                    .asSignalOnErrorJustComplete()
            }
        
        let loggedInWithApple = input.appleLoginRequest
            .flatMapFirst {
                let rawNonce = randomNonceString()
                return self.loginWithAppleUseCase.execute(withRawNonce: rawNonce)
                    .flatMap { authorization in
                        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                              let idTokenData = appleIDCredential.identityToken,
                              let idTokenString = String(data: idTokenData, encoding: .utf8)
                        else {
                            throw ASAuthorizationError(.failed)
                        }
                        
                        let name = appleIDCredential.fullName?.formatted() ?? ""
                        let email = appleIDCredential.email ?? ""
                        
                        ItsMEUserDefaults.isLoggedInAsApple = true
                        ItsMEUserDefaults.setAppleUserID(appleIDCredential.user)
                        
                        let authorizationCode: String = try {
                            let codeData = try unwrapOrThrow(appleIDCredential.authorizationCode)
                            return try unwrapOrThrow(String(data: codeData, encoding: .utf8))
                        }()
                        
                        let signInToFirebase = self.signInToFirebaseUseCase.execute(withIDToken: idTokenString, providerID: .apple, rawNonce: rawNonce)
                            .mapToVoid()
                        let saveAppleIDRefreshToken = self.saveAppleIDRefreshTokenToKeychainUseCase.execute(authorizationCode: authorizationCode)
                        
                        return signInToFirebase.flatMap { _ in
                            return saveAppleIDRefreshToken
                        }
                        .map { return (name: name, email: email) }
                    }
                    .asSignalOnErrorJustComplete()
            }
        
        let loggedInAndNeedsSignUp = Signal.merge(loggedInWithKakao, loggedInWithApple)
            .flatMapFirst { nameAndEmail in
                return self.userRepository.hasUserProfile
                    .doOnSuccess { hasUserInfo in
                        ItsMEUserDefaults.allowsAutoLogin = hasUserInfo
                    }
                    .map { hasUserInfo in
                        return hasUserInfo ? NeedSignUp.notNeeded : NeedSignUp.needed(name: nameAndEmail.0,
                                                                                      email: nameAndEmail.1)
                    }
                    .asSignalOnErrorJustComplete()
            }
        
        return .init(loggedInAndNeedsSignUp: loggedInAndNeedsSignUp)
    }
}

// MARK: - Input & Output

extension LoginViewModel {
    
    struct Input {
        let kakaoLoginRequest: Signal<Void>
        let appleLoginRequest: Signal<Void>
    }
    
    struct Output {
        let loggedInAndNeedsSignUp: Signal<NeedSignUp>
    }
}

// MARK: - NeedSignUp

extension LoginViewModel {
    
    enum NeedSignUp {
        case needed(name: String, email: String)
        case notNeeded
    }
}
