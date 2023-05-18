//
//  GetCurrentAuthProviderIDUseCaseMock.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/17.
//

@testable import ItsME
import RxSwift

struct GetCurrentAuthProviderIDUseCaseMock: GetCurrentAuthProviderIDUseCaseProtocol {
    
    var authProviderID: AuthProviderID
    var hasError: Bool
    
    func execute() -> Single<AuthProviderID> {
        if hasError {
            return .error(TestError.testError)
        } else {
            return .just(authProviderID)
        }
    }
}
