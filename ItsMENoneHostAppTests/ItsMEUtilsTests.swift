//
//  ItsMEUtilsTests.swift
//  ItsMETestsWithoutApp
//
//  Created by Jaewon Yun on 2023/04/18.
//

import XCTest
@testable import ItsME

final class ItsMEUtilsTests: XCTestCase {
    
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
}
