//
//  SaveUserProfileUseCaseMock.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/18.
//

@testable import ItsME
import RxSwift

struct SaveUserProfileUseCaseMock: SaveUserProfileUseCaseProtocol {
    
    var hasError: Bool
    
    func execute(with userProfile: UserProfile) -> Single<Void> {
        if hasError {
            return .error(TestError.testError)
        } else {
            return .just(())
        }
    }
}
