//
//  LogoutUseCaseMock.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/18.
//

@testable import ItsME
import RxSwift

struct LogoutUseCaseMock: LogoutUseCaseProtocol {
    
    var hasError: Bool
    
    func execute() -> Completable {
        if hasError {
            return .error(TestError.testError)
        } else {
            return .empty()
        }
    }
}
