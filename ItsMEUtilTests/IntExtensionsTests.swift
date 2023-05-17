//
//  IntExtensionsTests.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/03/06.
//

import ItsMEUtil
import XCTest

final class IntExtensionsTests: XCTestCase {
    
    func test_toLeadingZero_보통상황() {
        // Arrange
        let num = 1
        // Act
        let leadingZeroString = num.toLeadingZero(digit: 2)
        // Assert
        XCTAssertEqual(leadingZeroString, "01")
    }
    
    func test_toLeadingZero_음수() {
        // Arrange
        let num = -1
        // Act
        let leadingZeroString = num.toLeadingZero(digit: 2)
        // Assert
        XCTAssertEqual(leadingZeroString, "-01")
    }
    
    func test_toLeadingZero_주어진_자릿수가_작을때() {
        // Arrange
        let num = 1111
        // Act
        let leadingZeroString = num.toLeadingZero(digit: 2)
        // Assert
        XCTAssertEqual(leadingZeroString, "1111")
    }
    
    func test_toLeadingZero_주어진_자릿수가_작을때_AND_음수() {
        // Arrange
        let num = -1111
        // Act
        let leadingZeroString = num.toLeadingZero(digit: 2)
        // Assert
        XCTAssertEqual(leadingZeroString, "-1111")
    }
    
    func test_toLeadingZero_0일때() {
        // Arrange
        let num = 0
        // Act
        let leadingZeroString = num.toLeadingZero(digit: 3)
        // Assert
        XCTAssertEqual(leadingZeroString, "000")
    }
}
