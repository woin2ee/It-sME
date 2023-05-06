//
//  RevokeAppleIDRefreshTokenUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Foundation

struct RevokeAppleIDRefreshTokenUseCase: UseCase {
    
    struct Input {
        let refreshToken: String
        let completionHandler: (Result<Void, Error>) -> Void
    }
    
    func execute(input: Input) -> Void {
        AppleRESTAPI.revokeToken(
            input.refreshToken,
            tokenTypeHint: .refreshToken,
            completionHandler: input.completionHandler
        )
    }
}
