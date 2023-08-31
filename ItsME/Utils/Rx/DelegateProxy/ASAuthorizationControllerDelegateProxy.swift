//
//  ASAuthorizationControllerDelegateProxy.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/25.
//

import AuthenticationServices
import RxSwift
import RxCocoa
import UIKit

@available(iOS 13.0, *)
class ASAuthorizationControllerDelegateProxy:
    DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>,
    DelegateProxyType {

    static func registerKnownImplementations() {
        self.register { parent in
            ASAuthorizationControllerDelegateProxy.init(
                parentObject: parent,
                delegateProxy: ASAuthorizationControllerDelegateProxy.self
            )
        }
    }

    static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
        object.delegate
    }

    static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
        object.delegate = delegate
    }
}

@available(iOS 13.0, *)
extension ASAuthorizationControllerDelegateProxy:
    ASAuthorizationControllerDelegate,
    ASAuthorizationControllerPresentationContextProviding {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        #if DEBUG
            print(error.localizedDescription)
        #endif
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIWindow.init()
    }
}
