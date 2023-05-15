//
//  SignInToFirebaseUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import FirebaseAuth
import Foundation
import RxSwift

protocol SignInToFirebaseUseCaseProtocol {
    func execute(
        withIDToken idToken: String,
        providerID: AuthProviderID,
        rawNonce: String
    ) -> Single<AuthDataResult>
}

struct SignInToFirebaseUseCase: SignInToFirebaseUseCaseProtocol {
    
    // MARK: Shared Instance
    
    static let shared: SignInToFirebaseUseCase = .init()
    
    // MARK: Execute
    
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
