//
//  SaveAppleIDRefreshTokenToKeychainUseCase+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Foundation
import RxSwift

extension SaveAppleIDRefreshTokenToKeychainUseCase: ReactiveCompatible {}

extension Reactive where Base == SaveAppleIDRefreshTokenToKeychainUseCase {
    
    func execute(authorizationCode: String) -> Single<Void> {
        return .create { observer in
            self.base.execute(authorizationCode: authorizationCode) { result in
                switch result {
                case .success(_):
                    observer(.success(()))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
