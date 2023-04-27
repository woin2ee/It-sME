//
//  RevokeAppleIDRefreshTokenUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Alamofire
import Foundation
import RxSwift

struct RevokeAppleIDRefreshTokenUseCase {
    
    func execute(refreshToken: String, completion: @escaping ((Result<(), Error>) -> Void)) {
        let parameters: AppleIDTokenRevocationRequestDTO = .init(
            clientSecret: "eyJhbGciOiJFUzI1NiIsImtpZCI6IjVYM1pEN1I5MjcifQ.eyJpc3MiOiIyQVZDOFg3MzIzIiwiaWF0IjoxNjgyNDk3NDQ3LCJleHAiOjE2OTU0NTc0ODQsImF1ZCI6Imh0dHBzOi8vYXBwbGVpZC5hcHBsZS5jb20iLCJzdWIiOiJjb20uSUxHT0IuSXRzTUUifQ.WfEfiPD_aD-kh7nos0pfcM58rKbg9FIdYhaLHxrrvk3sqF2tMSvLoOiFiXdaoFEHrCf2QPzTsfziweUjDNh_vA",
            token: refreshToken,
            tokenTypeHint: .refreshToken
        )
        
        AF.request(
            "https://appleid.apple.com/auth/revoke",
            method: .post,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder.default
        )
        .response { response in
            switch response.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func execute(refreshToken: String) -> Single<Void> {
        return .create { observer in
            self.execute(refreshToken: refreshToken) { result in
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

// MARK: - AppleIDTokenRevocationRequestDTO

extension RevokeAppleIDRefreshTokenUseCase {
    
    final class AppleIDTokenRevocationRequestDTO: Encodable {
        
        enum CodingKeys: String, CodingKey {
            case clientID = "client_id"
            case clientSecret = "client_secret"
            case token
            case tokenTypeHint = "token_type_hint"
        }
        
        enum TokenTypeHint: String, Encodable {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
        }
        
        let clientID: String
        let clientSecret: String
        let token: String
        let tokenTypeHint: TokenTypeHint?
        
        init(
            clientID: String = Bundle.main.identifier,
            clientSecret: String,
            token: String,
            tokenTypeHint: TokenTypeHint? = nil
        ) {
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.token = token
            self.tokenTypeHint = tokenTypeHint
        }
    }
}
