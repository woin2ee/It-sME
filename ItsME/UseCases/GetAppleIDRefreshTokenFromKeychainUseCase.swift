//
//  GetAppleIDRefreshTokenFromKeychainUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Foundation
import ItsMEUtil
import Keychaining

protocol GetAppleIDRefreshTokenFromKeychainUseCaseProtocol {
    func execute() throws -> String
}

struct GetAppleIDRefreshTokenFromKeychainUseCase: GetAppleIDRefreshTokenFromKeychainUseCaseProtocol {
    
    // MARK: Shared Instance
    
    static let shared: GetAppleIDRefreshTokenFromKeychainUseCase = .init()
    
    // MARK: Execute
    
    func execute() throws -> String {
        let refreshTokenData = try Keychain.genericPassword.makeSearchQuery()
            .setLabel("refreshToken")
            .setReturnType(true, forKey: .returnData)
            .execute()
        let refreshToken = String.init(data: refreshTokenData, encoding: .utf8)
        return try unwrapOrThrow(refreshToken)
    }
}
