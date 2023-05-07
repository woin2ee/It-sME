//
//  RevokeAppleIDRefreshTokenUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Foundation
import RxSwift

protocol RevokeAppleIDRefreshTokenUseCaseProtocol {
    func execute(withRefreshToken refreshToken: String) -> Single<Void>
}

struct RevokeAppleIDRefreshTokenUseCase: RevokeAppleIDRefreshTokenUseCaseProtocol {
    
    func execute(withRefreshToken refreshToken: String) -> Single<Void> {
        return AppleRESTAPI.rx.revokeToken(refreshToken, tokenTypeHint: .refreshToken)
    }
}
