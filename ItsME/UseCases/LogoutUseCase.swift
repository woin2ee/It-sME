//
//  LogoutUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import FirebaseAuth
import Foundation
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift

protocol LogoutUseCaseProtocol {
    func execute() -> Completable
}

struct LogoutUseCase: LogoutUseCaseProtocol {
    
    // MARK: Dependencies
    
    let getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCase
    
    init(getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCase) {
        self.getCurrentAuthProviderIDUseCase = getCurrentAuthProviderIDUseCase
    }
    
    func execute() -> Completable {
        ItsMEUserDefaults.allowsAutoLogin = false
        
        let signOutFromFIRAuth = Auth.auth().rx.signOut()
        
        return getCurrentAuthProviderIDUseCase.execute()
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
