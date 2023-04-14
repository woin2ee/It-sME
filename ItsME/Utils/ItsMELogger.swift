//
//  ItsMELogger.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/10.
//

import Foundation
import OSLog

struct ItsMELogger {
    
    static var subsystem: String { "ItsME" }
    
    static let standard: Logger = .init(subsystem: subsystem, category: "ItsME")
    static let test: Logger = .init(subsystem: subsystem, category: "test")
    static let network: Logger = .init(subsystem: subsystem, category: "network")
    static let ui: Logger = .init(subsystem: subsystem, category: "ui")
}
