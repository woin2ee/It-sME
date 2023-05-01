//
//  LoginWithAppleUseCase+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import AuthenticationServices
import Foundation
import RxSwift

extension LoginWithAppleUseCase: ReactiveCompatible {}

extension Reactive where Base == LoginWithAppleUseCase {
    
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
