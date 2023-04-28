//
//  AppleIDTokenRevocationRequestDTO.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Foundation

extension AppleRESTAPI {
    
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
