//
//  SaveAppleIDRefreshTokenToKeychainUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Foundation
import Keychaining
import RxSwift

protocol SaveAppleIDRefreshTokenToKeychainUseCaseProtocol {
    func execute(authorizationCode: String) -> Single<Void>
}

struct SaveAppleIDRefreshTokenToKeychainUseCase: SaveAppleIDRefreshTokenToKeychainUseCaseProtocol {
    
    func execute(authorizationCode: String) -> Single<Void> {
        return AppleRESTAPI.rx.validateToken(withAuthorizationCode: authorizationCode)
            .map(\.refreshToken)
            .doOnSuccess { refreshToken in
                try Keychain.genericPassword.makeSaveQuery()
                    .setLabel("refreshToken")
                    .setValueType(.data(for: refreshToken), forKey: .valueData)
                    .execute()
            }
            .mapToVoid()
    }
}
