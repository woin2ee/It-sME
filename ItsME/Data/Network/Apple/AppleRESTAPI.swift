//
//  AppleRESTAPI.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Alamofire
import Foundation

struct AppleRESTAPI {
    
    struct EndPoint {
        static let token = "https://appleid.apple.com/auth/token"
        static let revoke = "https://appleid.apple.com/auth/revoke"
    }
    
    static func validateToken(
        withAuthorizationCode authorizationCode: String,
        completionHandler: @escaping ((Result<AppleIDTokenValidationResponseDTO, Error>) -> Void)
    ) {
        let parameters: AppleIDTokenValidationRequestDTO = .init(
            clientSecret: "eyJhbGciOiJFUzI1NiIsImtpZCI6IjVYM1pEN1I5MjcifQ.eyJpc3MiOiIyQVZDOFg3MzIzIiwiaWF0IjoxNjgyNDk3NDQ3LCJleHAiOjE2OTU0NTc0ODQsImF1ZCI6Imh0dHBzOi8vYXBwbGVpZC5hcHBsZS5jb20iLCJzdWIiOiJjb20uSUxHT0IuSXRzTUUifQ.WfEfiPD_aD-kh7nos0pfcM58rKbg9FIdYhaLHxrrvk3sqF2tMSvLoOiFiXdaoFEHrCf2QPzTsfziweUjDNh_vA", // 만료 기간: Sat Sep 23 2023 17:24:44 UTC+0900 (한국 표준시)
            code: authorizationCode,
            grantType: .authorizationCode
        )
        
        AF.request(
            EndPoint.token,
            method: .post,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder.default
        )
        .responseDecodable(of: AppleIDTokenValidationResponseDTO.self) { response in
            do {
                let tokenResponse = try unwrapOrThrow(response.value)
                completionHandler(.success(tokenResponse))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    
    static func revokeToken(
        _ token: String,
        tokenTypeHint: AppleIDTokenRevocationRequestDTO.TokenTypeHint,
        completionHandler: @escaping ((Result<Void, Error>) -> Void)
    ) {
        let parameters: AppleIDTokenRevocationRequestDTO = .init(
            clientSecret: "eyJhbGciOiJFUzI1NiIsImtpZCI6IjVYM1pEN1I5MjcifQ.eyJpc3MiOiIyQVZDOFg3MzIzIiwiaWF0IjoxNjgyNDk3NDQ3LCJleHAiOjE2OTU0NTc0ODQsImF1ZCI6Imh0dHBzOi8vYXBwbGVpZC5hcHBsZS5jb20iLCJzdWIiOiJjb20uSUxHT0IuSXRzTUUifQ.WfEfiPD_aD-kh7nos0pfcM58rKbg9FIdYhaLHxrrvk3sqF2tMSvLoOiFiXdaoFEHrCf2QPzTsfziweUjDNh_vA",
            token: token,
            tokenTypeHint: tokenTypeHint
        )
        
        AF.request(
            EndPoint.revoke,
            method: .post,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder.default
        )
        .response { response in
            switch response.result {
            case .success(_):
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
