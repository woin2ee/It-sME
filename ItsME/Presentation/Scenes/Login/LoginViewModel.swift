//
//  LoginViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/15.
//

import AuthenticationServices
import RxSwift
import RxCocoa
import KakaoSDKUser
import RxKakaoSDKUser

final class LoginViewModel: ViewModelType {
    
    struct Input {
        let kakaoLoginRequest: Signal<Void>
        let appleLoginSuccess: Driver<ASAuthorization>
    }
    
    struct Output {
        let loggedIn: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let loggedInKakao = input.kakaoLoginRequest
            .flatMapFirst {
                return self.loginWithKakao()
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let loggedInApple = input.appleLoginSuccess
            .flatMap { authorization -> Driver<Void> in
                guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                    return .empty()
                }
                return AppLoginStatusManager.shared.rx.login(with: .apple, uid: appleIDCredential.user)
                    .asDriverOnErrorJustComplete()
            }
        
        let loggedIn = Driver.merge(loggedInKakao, loggedInApple)
        
        return .init(loggedIn: loggedIn)
    }
}

// MARK: - Private Functions

private extension LoginViewModel {
    
    func loginWithKakao() -> Observable<Void> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .flatMap { authToken in
                    return UserApi.shared.rx.me()
                        .compactMap { $0.id }
                        .map { String($0) }
                }
                .flatMap { AppLoginStatusManager.shared.rx.login(with: .kakao, uid: $0) }
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount()
                .flatMap { authToken in
                    return UserApi.shared.rx.me()
                        .compactMap { $0.id }
                        .map { String($0) }
                }
                .flatMap { AppLoginStatusManager.shared.rx.login(with: .kakao, uid: $0) }
        }
    }
}
