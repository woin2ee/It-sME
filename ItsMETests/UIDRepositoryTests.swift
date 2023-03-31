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
    
    override func setUpWithError() throws {
        try sut.remove()
    }
    
    override func tearDownWithError() throws {
        try sut.remove()
    }
    
    func testGetUIDAfterSaveUID() throws {
        // Arrange
        let testUID: String! = "TestUID"
        try sut.save(testUID)
        
        // Act
        let currentUID = try sut.get()
        
        // Assert
        XCTAssertEqual(testUID, currentUID)
    }
    
    func testGetUIDWhenNotSaved() throws {
        // Act
        do {
            let currentUID = try sut.get()
            XCTFail("가져오기 실패를 예상했으나 성공함.")
        }
        
        // Assert
        catch {
            XCTAssert(true)
        }
    }
    
    func testSaveOtherUIDWhenAlreadyExistUID() throws {
        // Arrange
        let testUID: String! = "TestUID"
        try sut.save(testUID)
        let newTestUID = "newTestUID"
        
        // Act
        try sut.save(newTestUID)
        let currentUID = try sut.get()
        
        // Assert
        XCTAssertEqual(newTestUID, currentUID)
    }
}
