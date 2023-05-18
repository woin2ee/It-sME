//
//  LogoutUseCaseTests.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/15.
//

@testable import ItsME
import RxTest
import XCTest

final class LogoutUseCaseTests: RxBaseTestCase {
    
    var sut: LogoutUseCase!
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testSuccessWhenNormalCase() throws {
        // Arrange
        let sut: LogoutUseCase = makeSUT(with: .kakao, hasError: false)
        let trigger = testScheduler.createTrigger(emitAt: 300)
        
        // Act
        let result = testScheduler.start {
            trigger.flatMap { sut.execute() }
        }
        
        // Assert
        XCTAssertEqual(result.events, []) // Means no error emitted.
    }
    
    func testFailureDueToGetCurrentAuthProviderIDUseCaseError() {
        // Arrange
        let sut: LogoutUseCase = makeSUT(with: .kakao, hasError: true)
        let trigger = testScheduler.createTrigger(emitAt: 300)
        
        // Act
        let result = testScheduler.start {
            trigger.flatMap { sut.execute() }
        }
        
        // Assert
        let expectedResultEvents = [Recorded.error(300, TestError.testError, Never.self)]
        XCTAssertEqual(result.events, expectedResultEvents)
    }
}

// MARK: - Convenience Methods

extension LogoutUseCaseTests {
    
    private func makeSUT(with authProviderID: AuthProviderID, hasError: Bool) -> LogoutUseCase {
        let getCurrentAuthProviderIDUseCaseMock = GetCurrentAuthProviderIDUseCaseMock.init(authProviderID: authProviderID, hasError: hasError)
        let logoutWithAppleUseCase = LogoutWithAppleUseCaseDummy()
        return .init(
            getCurrentAuthProviderIDUseCase: getCurrentAuthProviderIDUseCaseMock,
            logoutWithAppleUseCase: logoutWithAppleUseCase
        )
    }
}
