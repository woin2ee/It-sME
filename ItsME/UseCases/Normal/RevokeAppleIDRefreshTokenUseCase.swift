//
//  RevokeAppleIDRefreshTokenUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Foundation

struct RevokeAppleIDRefreshTokenUseCase {
    
    static let shared: RevokeAppleIDRefreshTokenUseCase = .init()
    
    private init() {}
    
    func execute(refreshToken: String, completion: @escaping ((Result<(), Error>) -> Void)) {
        AppleRESTAPI.revokeToken(refreshToken, tokenTypeHint: .refreshToken, completionHandler: completion)
    }
}
