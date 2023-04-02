//
//  FIRAuth+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/03.
//

import FirebaseAuth
import RxSwift

extension Reactive where Base: Auth {
    
    func signIn(with credential: AuthCredential) -> Single<AuthDataResult?> {
        return .create { singleObserver in
            self.base.signIn(with: credential) { authDataResult, error in
                if let error = error {
                    singleObserver(.failure(error))
                }
                singleObserver(.success(authDataResult))
            }
            return Disposables.create()
        }
    }
}
