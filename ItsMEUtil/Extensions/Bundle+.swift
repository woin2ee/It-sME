//
//  Bundle+.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Foundation

extension Bundle {
    
    /// The receiver’s bundle identifier.
    ///
    /// If `receiver’s bundleIdentifier` is nil, stop the program.
    public var identifier: String {
        guard let identifier = self.bundleIdentifier else {
            preconditionFailure("bundleIdentifier is nil.")
        }
        return identifier
    }
    
    /// A 10-character key identifier generated for the Sign in with Apple private key associated with your developer account.
    public var signInAppleKeyID: String {
        let dictionaryKey = "SignInAppleKeyID"
        guard let keyID = self.object(forInfoDictionaryKey: dictionaryKey) as? String else {
            preconditionFailure("No \(dictionaryKey) key in info.plist file.")
        }
        return keyID
    }
    
    /// Team ID based on `info.plist`.
    public var teamID: String {
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
