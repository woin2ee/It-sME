//
//  AppleIDTokenValidationRequestDTO.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Foundation

extension AppleRESTAPI {
    
    final class AppleIDTokenValidationRequestDTO: Encodable {
        
        enum CodingKeys: String, CodingKey {
            case clientID = "client_id"
            case clientSecret = "client_secret"
            case code
            case grantType = "grant_type"
        }
        
        enum GrantType: String, Encodable {
            case authorizationCode = "authorization_code"
            case refreshToken = "refresh_token"
        }
        
        let clientID: String
        let clientSecret: String
        let code: String?
        let grantType: GrantType
        
        init(
            clientID: String = Bundle.main.identifier,
            clientSecret: String,
            code: String?,
            grantType: GrantType
        ) {
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.code = code
            self.grantType = grantType
        }
    }
}
