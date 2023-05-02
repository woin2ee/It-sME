//
//  LogoutUseCase+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import FirebaseAuth
import Foundation
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift

extension LogoutUseCase: ReactiveCompatible {}

extension Reactive where Base == LogoutUseCase {
    
    func execute() -> Completable {
        ItsMEUserDefaults.allowsAutoLogin = false
        
        let signOutFromFIRAuth = Auth.auth().rx.signOut()
        
        return self.base.getCurrentAuthProviderIDUseCase.rx.execute()
            .flatMapCompletable { providerID in
                switch providerID {
                case .kakao:
                    let logoutWithKakao = UserApi.shared.rx.logout()
                    return Completable.zip(logoutWithKakao, signOutFromFIRAuth)
                case .apple:
                    ItsMEUserDefaults.removeAppleUserID()
                    ItsMEUserDefaults.isLoggedInAsApple = false
                    let logoutWithApple: Completable = .empty()
                    return Completable.zip(logoutWithApple, signOutFromFIRAuth)
                }
            }
    }
}
