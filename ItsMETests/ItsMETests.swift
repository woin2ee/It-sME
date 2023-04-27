//
//  ItsMETests.swift
//  ItsMETests
//
//  Created by MacBook Air on 2022/11/07.
//

import XCTest
@testable import ItsME

final class ItsMETests: XCTestCase {
    
    func testGetTeamID() {
        // Arrange
        let teamIDForInfoDictionary: String
        let currentSignedTeamID = "2AVC8X7323"
        
        // Act
        teamIDForInfoDictionary = Bundle.main.teamID
        
        // Assert
        XCTAssertEqual(teamIDForInfoDictionary, currentSignedTeamID)
    }
}
