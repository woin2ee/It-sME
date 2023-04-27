//
//  SaveAppleIDRefreshTokenToKeychainUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Alamofire
import Foundation
import Keychaining
import RxSwift

struct SaveAppleIDRefreshTokenToKeychainUseCase {
    
    func execute(authorizationCode: String, completion: @escaping ((Result<(), Error>) -> Void)) {
        let parameters: AppleIDTokenValidationRequestDTO = .init(
            clientSecret: "eyJhbGciOiJFUzI1NiIsImtpZCI6IjVYM1pEN1I5MjcifQ.eyJpc3MiOiIyQVZDOFg3MzIzIiwiaWF0IjoxNjgyNDk3NDQ3LCJleHAiOjE2OTU0NTc0ODQsImF1ZCI6Imh0dHBzOi8vYXBwbGVpZC5hcHBsZS5jb20iLCJzdWIiOiJjb20uSUxHT0IuSXRzTUUifQ.WfEfiPD_aD-kh7nos0pfcM58rKbg9FIdYhaLHxrrvk3sqF2tMSvLoOiFiXdaoFEHrCf2QPzTsfziweUjDNh_vA", // 만료 기간: Sat Sep 23 2023 17:24:44 UTC+0900 (한국 표준시)
            code: authorizationCode,
            grantType: .authorizationCode
        )
        
        AF.request(
            "https://appleid.apple.com/auth/token",
            method: .post,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder.default
        )
        .responseDecodable(of: AppleIDTokenValidationResponseDTO.self) { response in
            do {
                let refreshToken = try unwrapOrThrow(response.value?.refreshToken)
                try Keychain.genericPassword.makeSaveQuery()
                    .setLabel("refreshToken")
                    .setValueType(.data(for: refreshToken), forKey: .valueData)
                    .execute()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func execute(authorizationCode: String) -> Single<Void> {
        return .create { observer in
            self.execute(authorizationCode: authorizationCode) { result in
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

// MARK: - AppleIDTokenValidationRequestDTO

extension SaveAppleIDRefreshTokenToKeychainUseCase {
    
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
        let code: String
        let grantType: GrantType
        
        init(
            clientID: String = Bundle.main.identifier,
            clientSecret: String,
            code: String,
            grantType: GrantType
        ) {
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.code = code
            self.grantType = grantType
        }
    }
}

// MARK: - AppleIDTokenValidationResponseDTO

extension SaveAppleIDRefreshTokenToKeychainUseCase {
    
    struct AppleIDTokenValidationResponseDTO: Decodable {
        
        enum CodingKeys: String, CodingKey {
            case refreshToken = "refresh_token"
        }
        
        let refreshToken: String
    }
}
