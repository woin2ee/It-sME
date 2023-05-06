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
        do {
            // Arrange
            let arr: [CGFloat] = [0.1, 0.2, 0.3, 0.4, 0.5]
            
            // Act
            let value = closestValue(0.31, in: arr)
            
            // Assert
            XCTAssertEqual(value, 0.3)
        }
        do {
            // Arrange
            let arr: [CGFloat] = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4]
            
            // Act
            let value = closestValue(-1.9, in: arr)
            
            // Assert
            XCTAssertEqual(value, -2)
        }
        do {
            // Arrange
            let arr: [CGFloat] = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4]
            
            // Act
            let value = closestValue(-0.4, in: arr)
            
            // Assert
            XCTAssertEqual(value, 0)
        }
        // Only One element
        do {
            // Arrange
            let arr: [CGFloat] = [-3]
            
            // Act
            let value = closestValue(-9999, in: arr)
            
            // Assert
            XCTAssertEqual(value, -3)
        }
        // No Element
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
