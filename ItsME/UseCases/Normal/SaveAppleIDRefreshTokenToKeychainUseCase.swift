//
//  SaveAppleIDRefreshTokenToKeychainUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Foundation
import Keychaining

struct SaveAppleIDRefreshTokenToKeychainUseCase: UseCase {
    
    struct Input {
        let authorizationCode: String
        let completionHandler: (Result<Void, Error>) -> Void
    }
    
    func execute(input: Input) -> Void {
        AppleRESTAPI.validateToken(withAuthorizationCode: input.authorizationCode) { result in
            switch result {
            case .success(let response):
                do {
                    try Keychain.genericPassword.makeSaveQuery()
                        .setLabel("refreshToken")
                        .setValueType(.data(for: response.refreshToken), forKey: .valueData)
                        .execute()
                    input.completionHandler(.success(()))
                } catch {
                    input.completionHandler(.failure(error))
                }
            case .failure(let error):
                input.completionHandler(.failure(error))
            }
        }
    }
}
