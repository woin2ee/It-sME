//
//  AppleRESTAPI+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Foundation
import RxSwift

protocol RxAppleRESTAPIProtocol: AppleRESTAPIProtocol {

    static func validateToken(withAuthorizationCode authorizationCode: String) -> Single<ResponseDTO>

    static func revokeToken(_ token: String, tokenTypeHint: TokenTypeHint) -> Single<Void>
}

extension AppleRESTAPI: RxAppleRESTAPIProtocol {

    static func validateToken(
        withAuthorizationCode authorizationCode: String
    ) -> Single<AppleIDTokenValidationResponseDTO> {
        return .create { observer in
            validateToken(withAuthorizationCode: authorizationCode) { result in
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
        tokenTypeHint: AppleIDTokenRevocationRequestDTO.TokenTypeHint
    ) -> Single<Void> {
        return .create { observer in
            revokeToken(token, tokenTypeHint: tokenTypeHint) { result in
                switch result {
                case .success:
                    observer(.success(()))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
