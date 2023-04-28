//
//  Bundle+Identifier.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/26.
//

import Foundation

extension Bundle {
    
    /// The receiver’s bundle identifier.
    ///
    /// If `receiver’s bundleIdentifier` is nil, stop the program.
    var identifier: String {
        guard let identifier = self.bundleIdentifier else {
            preconditionFailure("bundleIdentifier is nil.")
        }
        return identifier
    }
}
