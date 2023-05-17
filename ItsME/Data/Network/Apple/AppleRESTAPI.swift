//
//  AppleRESTAPI.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Alamofire
import FirebaseStorage
import Foundation
import ItsMEUtil
import SwiftJWT

protocol AppleRESTAPIProtocol {
    
    associatedtype TokenTypeHint: Encodable
    associatedtype ResponseDTO: Decodable
    
    static func validateToken(
        withAuthorizationCode authorizationCode: String,
        completionHandler: @escaping ((Result<ResponseDTO, Error>) -> Void)
    )
    
    static func revokeToken(
        _ token: String,
        tokenTypeHint: TokenTypeHint,
        completionHandler: @escaping ((Result<Void, Error>) -> Void)
    )
}

struct AppleRESTAPI {
    
    struct EndPoint {
        static let token = "https://appleid.apple.com/auth/token"
        static let revoke = "https://appleid.apple.com/auth/revoke"
    }
    
    static func validateToken(
        withAuthorizationCode authorizationCode: String,
        completionHandler: @escaping ((Result<AppleIDTokenValidationResponseDTO, Error>) -> Void)
    ) {
        makeClientSecret { result in
            switch result {
            case .success(let clientSecret):
                let parameters: AppleIDTokenValidationRequestDTO = .init(
                    clientSecret: clientSecret,
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
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    static func revokeToken(
        _ token: String,
        tokenTypeHint: AppleIDTokenRevocationRequestDTO.TokenTypeHint,
        completionHandler: @escaping ((Result<Void, Error>) -> Void)
    ) {
        makeClientSecret { result in
            switch result {
            case .success(let clientSecret):
                let parameters: AppleIDTokenRevocationRequestDTO = .init(
                    clientSecret: clientSecret,
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
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

extension AppleRESTAPI {
    
    private static func makeClientSecret(completionHandler: @escaping ((Result<String, Error>) -> Void)) {
        
        struct ClientSecretClaims: Claims {
            let iss: String
            let iat: Date
            let exp: Date
            let aud: String
            let sub: String
        }
        
        let header = Header(kid: Bundle.main.signInAppleKeyID)
        let now: Date = .now
        let claims = ClientSecretClaims(
            iss: Bundle.main.teamID,
            iat: now,
            exp: now.addingTimeInterval(300),
            aud: "https://appleid.apple.com",
            sub: Bundle.main.identifier
        )
        var jwt = JWT(header: header, claims: claims)
        
        Storage.storage().reference().child("credentials").child("AuthKey_5X3ZD7R927.p8")
            .getData(maxSize: 1 * 1024) { result in
                switch result {
                case .success(let privateKeyData):
                    let jwtSigner = JWTSigner.es256(privateKey: privateKeyData)
                    do {
                        let signedJWT = try jwt.sign(using: jwtSigner)
                        completionHandler(.success(signedJWT))
                    } catch {
                        completionHandler(.failure(error))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
}
