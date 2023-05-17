//
//  LoginWithAppleUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import AuthenticationServices
import ItsMEUtil
import RxSwift

protocol LoginWithAppleUseCaseProtocol {
    func execute(withRawNonce rawNonce: String) -> Observable<ASAuthorization>
}

struct LoginWithAppleUseCase: LoginWithAppleUseCaseProtocol {
    
    // MARK: Shared Instance
    
    static let shared: LoginWithAppleUseCase = .init()
    
    // MARK: Execute
    
    func execute(withRawNonce rawNonce: String) -> Observable<ASAuthorization> {
        let appleIDProvider = ASAuthorizationAppleIDProvider.init()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(rawNonce)
        
        let authorizationController = ASAuthorizationController.init(authorizationRequests: [request])
        authorizationController.performRequests()
        
        return authorizationController.rx.didCompleteWithAuthorization
    }
}
