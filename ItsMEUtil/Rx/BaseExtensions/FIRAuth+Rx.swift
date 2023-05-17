//
//  FIRAuth+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/03.
//

import FirebaseAuth
import RxSwift

extension Reactive where Base: Auth {
    
    public func signIn(with credential: AuthCredential) -> Single<AuthDataResult> {
        return .create { singleObserver in
            Task {
                do {
                    let authDataResult = try await self.base.signIn(with: credential)
                    singleObserver(.success(authDataResult))
                } catch {
                    singleObserver(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    public func signOut() -> Completable {
        return .create { observer in
            do {
                try self.base.signOut()
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    public var currentUser: Single<User> {
        guard let currentUser = Auth.auth().currentUser else {
            return .error(AuthErrorCode(.nullUser))
        }
        return .just(currentUser)
    }
}
