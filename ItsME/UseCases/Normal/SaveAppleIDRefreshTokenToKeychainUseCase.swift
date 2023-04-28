//
//  SaveAppleIDRefreshTokenToKeychainUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Foundation
import Keychaining

struct SaveAppleIDRefreshTokenToKeychainUseCase {
    
    func execute(authorizationCode: String, completion: @escaping ((Result<(), Error>) -> Void)) {
        AppleRESTAPI.validateToken(withAuthorizationCode: authorizationCode) { result in
            switch result {
            case .success(let response):
                do {
                    try Keychain.genericPassword.makeSaveQuery()
                        .setLabel("refreshToken")
                        .setValueType(.data(for: response.refreshToken), forKey: .valueData)
                        .execute()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
