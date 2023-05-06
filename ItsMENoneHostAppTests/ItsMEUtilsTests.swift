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
}
