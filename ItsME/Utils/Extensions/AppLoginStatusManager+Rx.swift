//
//  AppLoginStatusManager+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/16.
//

import RxSwift

extension Reactive where Base: AppLoginStatusManager {
    
    func login(with uid: UIDRepository.UID) -> Single<Void> {
        return Single
            .create { observer in
                do {
                    try AppLoginStatusManager.shared.login(with: uid)
                    observer(.success(()))
                } catch {
                    observer(.failure(AppLoginStatusManager.AppLoginError.loginFail))
                }
                return Disposables.create()
            }
            .observe(on: MainScheduler.instance)
    }
}

extension AppLoginStatusManager: ReactiveCompatible {}
