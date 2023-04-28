//
//  AppleRESTAPI+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Foundation
import RxSwift

extension AppleRESTAPI: ReactiveCompatible {}

extension Reactive where Base == AppleRESTAPI {
    
    static func validateToken(
        withAuthorizationCode authorizationCode: String
    ) -> Single<Base.AppleIDTokenValidationResponseDTO> {
        return .create { observer in
            Base.validateToken(withAuthorizationCode: authorizationCode) { result in
                switch result {
                case .success(let response):
                    observer(.success(response))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    static func revokeToken(
        _ token: String,
        tokenTypeHint: Base.AppleIDTokenRevocationRequestDTO.TokenTypeHint
    ) -> Single<Void> {
        return .create { observer in
            Base.revokeToken(token, tokenTypeHint: tokenTypeHint) { result in
                switch result {
                case .success(_):
                    observer(.success(()))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}

