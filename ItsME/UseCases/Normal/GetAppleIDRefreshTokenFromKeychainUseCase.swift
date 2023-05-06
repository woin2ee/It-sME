//
//  GetAppleIDRefreshTokenFromKeychainUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Foundation
import Keychaining

struct GetAppleIDRefreshTokenFromKeychainUseCase: UseCase {
    
    func execute(input: Void = ()) throws -> String {
        let refreshTokenData = try Keychain.genericPassword.makeSearchQuery()
            .setLabel("refreshToken")
            .setReturnType(true, forKey: .returnData)
            .execute()
        let refreshToken = String.init(data: refreshTokenData, encoding: .utf8)
        return try unwrapOrThrow(refreshToken)
    }
}
