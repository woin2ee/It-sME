//
//  LoginViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/15.
//

import RxSwift
import RxCocoa
import KakaoSDKUser
import RxKakaoSDKUser

final class LoginViewModel: ViewModelType {
    
    struct Input {
        let kakaoLoginRequest: Signal<Void>
        let appleLoginRequest: Signal<Void>
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
        
        let loggedInApple = input.appleLoginRequest
            .asDriver(onErrorDriveWith: .empty())
        
        let loggedIn = Driver.merge(loggedInKakao, loggedInApple)
        
        return .init(loggedIn: loggedIn)
    }
}

// MARK: - Private Functions

private extension LoginViewModel {
    
    func loginWithKakao() -> Observable<Void> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .map { AuthToken -> Void in
                    #if DEBUG
                        print("Login Success")
                        print(AuthToken.accessToken)
                    #endif
                    return ()
                }
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount()
                .map { AuthToken -> Void in
                    #if DEBUG
                        print("Login Success")
                        print(AuthToken.accessToken)
                    #endif
                    return ()
                }
        }
    }
}
