//
//  GetCurrentAuthProviderIDUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import FirebaseAuth
import Foundation
import RxSwift

protocol GetCurrentAuthProviderIDUseCaseProtocol {
    func execute() -> Single<AuthProviderID>
}

struct GetCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCaseProtocol {

    // MARK: Shared Instance

    static let shared: GetCurrentAuthProviderIDUseCase = .init()

    // MARK: Execute

    func execute() -> Single<AuthProviderID> {
        return Auth.auth().rx.currentUser
            .map(\.providerData.first)
            .unwrapOrThrow()
            .map { AuthProviderID(rawValue: $0.providerID) }
            .unwrapOrThrow()
    }
}
