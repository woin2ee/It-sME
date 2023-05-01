//
//  Bundle+SignInAppleKeyID.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/27.
//

import Foundation

extension Bundle {
    
    /// A 10-character key identifier generated for the Sign in with Apple private key associated with your developer account.
    var signInAppleKeyID: String {
        let dictionaryKey = "SignInAppleKeyID"
        guard let keyID = self.object(forInfoDictionaryKey: dictionaryKey) as? String else {
            preconditionFailure("No \(dictionaryKey) key in info.plist file.")
        }
        return keyID
    }
}
