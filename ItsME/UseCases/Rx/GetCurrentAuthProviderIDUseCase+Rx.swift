//
//  GetCurrentAuthProviderIDUseCase+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import FirebaseAuth
import Foundation
import RxSwift

extension GetCurrentAuthProviderIDUseCase: ReactiveCompatible {}

extension Reactive where Base == GetCurrentAuthProviderIDUseCase {
    
    func execute() -> Single<AuthProviderID> {
        return Auth.auth().rx.currentUser
            .map(\.providerData.first)
            .unwrapOrThrow()
            .map { AuthProviderID(rawValue: $0.providerID) }
            .unwrapOrThrow()
    }
}
