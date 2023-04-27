//
//  AppleIDTokenValidationResponseDTO.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Foundation

extension AppleRESTAPI {
    
    struct AppleIDTokenValidationResponseDTO: Decodable {
        
        enum CodingKeys: String, CodingKey {
            case refreshToken = "refresh_token"
        }
        
        let refreshToken: String
    }
}
