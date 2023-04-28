//
//  SignInToFirebaseUseCase+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import FirebaseAuth
import Foundation
import RxSwift

extension SignInToFirebaseUseCase: ReactiveCompatible {}

extension Reactive where Base == SignInToFirebaseUseCase {
    
    func execute(
        withIDToken idToken: String,
        providerID: AuthProviderID,
        rawNonce: String
    ) -> Single<AuthDataResult> {
        let credential = OAuthProvider.credential(
            withProviderID: providerID.rawValue,
            idToken: idToken,
            rawNonce: rawNonce
        )
        return Auth.auth().rx.signIn(with: credential)
    }
}
