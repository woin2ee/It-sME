//
//  AuthenticationServices+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/25.
//

import AuthenticationServices
import RxSwift
import RxCocoa
import UIKit

// MARK: - ASAuthorizationController+Rx

@available(iOS 13.0, *)
extension Reactive where Base: ASAuthorizationController {
    
    var delegateProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
        return ASAuthorizationControllerDelegateProxy.proxy(for: self.base)
    }
    
    var didCompleteWithAuthorization: Observable<ASAuthorization> {
        let selector = #selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithAuthorization:))
        return delegateProxy
            .methodInvoked(selector)
            .map { parameters in
                guard let authorization = parameters[1] as? ASAuthorization else {
                    throw RxCocoaError.castingError(object: parameters[1], targetType: ASAuthorization.self)
                }
                return authorization
            }
    }
}

// MARK: - ASAuthorizationAppleIDButton+Rx

@available(iOS 13.0, *)
extension Reactive where Base: ASAuthorizationAppleIDButton {
    
    func tapToLogin(scope: [ASAuthorization.Scope]? = nil) -> Observable<ASAuthorization> {
        return controlEvent(.touchUpInside)
            .flatMap {
                let appleIDProvider = ASAuthorizationAppleIDProvider.init()
                
                let request = appleIDProvider.createRequest()
                request.requestedScopes = scope
                
                let authorizationController = ASAuthorizationController.init(authorizationRequests: [request])
                authorizationController.performRequests()
                
                return authorizationController.rx.didCompleteWithAuthorization
            }
    }
    
    var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}
