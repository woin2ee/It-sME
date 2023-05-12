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
    
    let getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCaseProtocol
    let logoutWithAppleUseCase: LogoutWithAppleUseCaseProtocol
    
    init(
        getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCaseProtocol,
        logoutWithApple: LogoutWithAppleUseCaseProtocol
    ) {
        self.getCurrentAuthProviderIDUseCase = getCurrentAuthProviderIDUseCase
        self.logoutWithAppleUseCase = logoutWithApple
    }
    
    func execute() -> Completable {
        return getCurrentAuthProviderIDUseCase.execute()
            .flatMapCompletable { providerID in
                switch providerID {
                case .kakao:
                    ItsMEUserDefaults.allowsAutoLogin = false
                    let signOutFromFIRAuth = Auth.auth().rx.signOut()
                    let logoutWithKakao = UserApi.shared.rx.logout()
                    return Completable.zip(logoutWithKakao, signOutFromFIRAuth)
                case .apple:
                    logoutWithAppleUseCase.execute()
                    return .empty()
                }
            }
    }
}
