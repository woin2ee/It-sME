//
//  RevokeAppleIDRefreshTokenUseCase+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Foundation
import RxSwift

extension RevokeAppleIDRefreshTokenUseCase: ReactiveCompatible {}

extension Reactive where Base == RevokeAppleIDRefreshTokenUseCase {
    
    func execute(refreshToken: String) -> Single<Void> {
        return AppleRESTAPI.rx.revokeToken(refreshToken, tokenTypeHint: .refreshToken)
    }
}
