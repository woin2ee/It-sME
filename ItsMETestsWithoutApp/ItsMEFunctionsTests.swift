//
//  ItsMEFunctionsTests.swift
//  ItsMETestsWithoutApp
//
//  Created by Jaewon Yun on 2023/05/04.
//

import XCTest
@testable import ItsME

final class ItsMEFunctionsTests: XCTestCase {
    
    func testFormatPhoneNumber() {
    정상적인11자리:
        do {
            // Arrange
            let phoneNumber = "01012345678"
            let expectedPhoneNumber = "010-1234-5678"
            
            // Act
            let actualPhoneNumber = formatPhoneNumber(phoneNumber)
            
            // Assert
            XCTAssertEqual(actualPhoneNumber, expectedPhoneNumber)
        }
    정상적인10자리:
        do {
            // Arrange
            let phoneNumber = "0101234567"
            let expectedPhoneNumber = "010-123-4567"
            
            // Act
            let actualPhoneNumber = formatPhoneNumber(phoneNumber)
            
            // Assert
            XCTAssertEqual(actualPhoneNumber, expectedPhoneNumber)
        }
    초과된자릿수:
        do {
            // Arrange
            let phoneNumber = "01012345678910"
            let expectedPhoneNumber = "01012345678910"
            
            // Act
            let actualPhoneNumber = formatPhoneNumber(phoneNumber)
            
            // Assert
            XCTAssertEqual(actualPhoneNumber, expectedPhoneNumber)
        }
    초과된하이픈자릿수:
        do {
            // Arrange
            let phoneNumber = "010-1234-5678910"
            let expectedPhoneNumber = "01012345678910"
            
            // Act
            let actualPhoneNumber = formatPhoneNumber(phoneNumber)
            
            // Assert
            XCTAssertEqual(actualPhoneNumber, expectedPhoneNumber)
        }
    입력중5자리:
        do {
            // Arrange
            let phoneNumber = "01012"
            let expectedPhoneNumber = "010-12"
            
            // Act
            let actualPhoneNumber = formatPhoneNumber(phoneNumber)
            
            // Assert
            XCTAssertEqual(actualPhoneNumber, expectedPhoneNumber)
        }
    입력중하이픈5자리:
        do {
            // Arrange
            let phoneNumber = "010-12"
            let expectedPhoneNumber = "010-12"
            
            // Act
            let actualPhoneNumber = formatPhoneNumber(phoneNumber)
            
            // Assert
            XCTAssertEqual(actualPhoneNumber, expectedPhoneNumber)
        }
    입력중8자리:
        do {
            // Arrange
            let phoneNumber = "01012345"
            let expectedPhoneNumber = "010-123-45"
            
            // Act
            let actualPhoneNumber = formatPhoneNumber(phoneNumber)
            
            // Assert
            XCTAssertEqual(actualPhoneNumber, expectedPhoneNumber)
        }
    입력중하이픈8자리:
        do {
            // Arrange
            let phoneNumber = "010-123-45"
            let expectedPhoneNumber = "010-123-45"
            
            // Act
            let actualPhoneNumber = formatPhoneNumber(phoneNumber)
            
            // Assert
            XCTAssertEqual(actualPhoneNumber, expectedPhoneNumber)
        }
    숫자가아닌무언가:
        do {
            // Arrange
            let phoneNumber = "숫자가아닙니다"
            let expectedPhoneNumber = "숫자가아닙니다"
            
            // Act
            let actualPhoneNumber = formatPhoneNumber(phoneNumber)
            
            // Assert
            XCTAssertEqual(actualPhoneNumber, expectedPhoneNumber)
        }
    }
}
