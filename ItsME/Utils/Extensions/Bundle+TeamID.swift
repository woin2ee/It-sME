//
//  Bundle+TeamID.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Foundation

extension Bundle {
    
    /// Team ID based on `info.plist`.
    var teamID: String {
        let dictionaryKey = "TeamID"
        guard let teamIDWithDot = self.object(forInfoDictionaryKey: dictionaryKey) as? String else {
            preconditionFailure("No \(dictionaryKey) key in info.plist file.")
        }
        guard let teamID = teamIDWithDot.components(separatedBy: ".").first else {
            preconditionFailure("Check the teamID.")
        }
        return teamID
    }
}
