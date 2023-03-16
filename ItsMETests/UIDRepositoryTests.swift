//
//  UIDRepositoryTests.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/03/14.
//

import XCTest
@testable import ItsME

final class UIDRepositoryTests: XCTestCase {
    
    let sut: UIDRepository! = .shared
    
    override func tearDown() {
        sut.removeUID()
    }
    
    func testGetUIDAfterSaveUID() {
        // Arrange
        let testUID: String! = "TestUID"
        saveUID(testUID)
        let expectedUID: String! = testUID
        
        // Act
        let currentUID = getUID()
        
        // Assert
        XCTAssertEqual(expectedUID, currentUID)
    }
    
    func testGetUIDWhenNotSaved() {
        // Act
        let currentUID = getUID()
        
        // Assert
        XCTAssertNil(currentUID)
    }
    
    func testUpdateUIDWhenExistSavedUID() {
        // Arrange
        let testUID: String! = "TestUID"
        saveUID(testUID)
        let newTestUID = "newTestUID"
        
        // Act
        updateUID(newTestUID)
        let currentUID = getUID()
        
        // Assert
        XCTAssertEqual(newTestUID, currentUID)
    }
    
    func testUpdateUIDWhenNotSaved() {
        // Arrange
        let newTestUID: String! = "newTestUID"
        var expectedStatus: OSStatus = errSecSuccess
        
        // Act
        let expectation = expectation(description: "UID update 가 수행된 후 fulfill 됩니다.")
        sut.updateUID(newTestUID) { status in
            expectedStatus = status
            expectation.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: .infinity) { _ in
            XCTAssertNotEqual(expectedStatus, errSecSuccess)
        }
    }
    
    func testSaveOtherUIDWhenAlreadyExistUID() {
        // Arrange
        let testUID: String! = "TestUID"
        saveUID(testUID)
        let newTestUID = "newTestUID"
        
        // Act
        let saveExpectation = expectation(description: "saveUID 의 excaping closure 가 호출된 후 fulfill 됩니다.")
        sut.saveUID(newTestUID) { status in
            saveExpectation.fulfill()
        }
        waitForExpectations(timeout: 2)
        let currentUID = getUID()
        
        // Assert
        XCTAssertEqual(newTestUID, currentUID)
    }
}

// MARK: - Private Functions

private extension UIDRepositoryTests {
    
    func saveUID(_ uid: String) {
        let saveExpectation = expectation(description: "saveUID 함수의 escaping closure 에서 fulfill() 이 호출됩니다.")
        
        sut.saveUID(uid) { status in
            if status == errSecSuccess || status == errSecDuplicateItem {
                saveExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("Time out. \(error) \(#function)")
            }
        }
    }
    
    func updateUID(_ newUID: String!) {
        let updateExpectation = expectation(description: "UID 가 업데이트 되고 난 뒤 fulfill 됩니다.")
        
        sut.updateUID(newUID) { status in
            updateExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("Time out. \(error) \(#function)")
            }
        }
    }
    
    func getUID() -> String? {
        var result: String? = nil
        
        let getExpectation = expectation(description: "getUID 함수의 escaping closure 에서 값이 모두 할당된 뒤 fulfill() 이 호출됩니다.")
        
        sut.getUID { status, uid in
            result = uid
            
            getExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("Time out. \(error) \(#function)")
            }
        }
        
        return result
    }
}
