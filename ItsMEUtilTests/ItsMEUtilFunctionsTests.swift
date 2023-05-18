//
//  ItsMEUtilFunctionsTests.swift
//  ItsMETestsWithoutApp
//
//  Created by Jaewon Yun on 2023/05/04.
//

import ItsMEUtil
import XCTest

final class ItsMEUtilFunctionsTests: XCTestCase {
    
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
    
    func test_closestValue() {
    NormalCase1:
        do {
            // Arrange
            let arr: [CGFloat] = [0.1, 0.2, 0.3, 0.4, 0.5]
            
            // Act
            let value = closestValue(0.31, in: arr)
            
            // Assert
            XCTAssertEqual(value, 0.3)
        }
    NormalCase2:
        do {
            // Arrange
            let arr: [CGFloat] = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4]
            
            // Act
            let value = closestValue(-1.9, in: arr)
            
            // Assert
            XCTAssertEqual(value, -2)
        }
    NormalCase3:
        do {
            // Arrange
            let arr: [CGFloat] = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4]
            
            // Act
            let value = closestValue(-0.4, in: arr)
            
            // Assert
            XCTAssertEqual(value, 0)
        }
    OnlyOneElement1:
        do {
            // Arrange
            let arr: [CGFloat] = [-3]
            
            // Act
            let value = closestValue(-9999, in: arr)
            
            // Assert
            XCTAssertEqual(value, -3)
        }
    OnlyOneElement2:
        do {
            // Arrange
            let arr: [CGFloat] = [3]
            
            // Act
            let value = closestValue(9999, in: arr)
            
            // Assert
            XCTAssertEqual(value, 3)
        }
    NoElement:
        do {
            // Arrange
            let arr: [CGFloat] = []
            
            // Act
            let value = closestValue(123, in: arr)
            
            // Assert
            XCTAssertNil(value)
        }
    }
    
    func test_castOrThrow() throws {
    SuccessCase:
        do {
            // Arrange
            let value: Any = 1
            var result: Int = 0
            
            // Act
            result = try castOrThrow(Int.self, value)
            
            // Assert
            XCTAssertEqual(result, value as! Int)
        }
    FailureCase:
        do {
            // Arrange
            let value: Any = "value"
            
            // Act
            do {
                _ = try castOrThrow(Int.self, value)
                XCTFail("String as? Int 을 성공함.")
            }
            
            // Assert
            catch {
                XCTAssert(true)
            }
        }
    }
    
    func test_unwrapOrThrow() throws {
    SuccessCase:
        do {
            // Arrange
            let value: Int? = 1
            var result: Int = -1
            
            // Act
            result = try unwrapOrThrow(value)
            
            // Assert
            XCTAssertEqual(result, value)
        }
    FailureCase:
        do {
            // Arrange
            let value: Int? = nil
            
            // Act
            do {
                _ = try unwrapOrThrow(value)
                XCTFail("nil 언래핑 성공.")
            }
            
            // Assert
            catch {
                XCTAssert(true)
            }
        }
    }
    
    func test_randomNonceString() {
        // Act
        let nonce = randomNonceString()
        
        // Assert
        XCTAssertNotEqual(nonce.count, 0)
    }
    
    func test_sha256() {
    WhenEmptyInput:
        do {
            // Arrange
            let input = ""
            
            // Act
            let result = sha256(input)
            
            // Assert
            XCTAssertEqual(result.count, 64)
        }
    WhenOneLengthInput:
        do {
            // Arrange
            let input = "a"
            
            // Act
            let result = sha256(input)
            
            // Assert
            XCTAssertEqual(result.count, 64)
        }
    WhenLongLengthInput:
        do {
            // Arrange
            let input = "aasdaaeifajij389faw38faw93f8awj9fajw38fjaw893jf98waj3f89ajw38fjwa893fj98aw3jf89aw3fa"
            
            // Act
            let result = sha256(input)
            
            // Assert
            XCTAssertEqual(result.count, 64)
        }
    }
}
