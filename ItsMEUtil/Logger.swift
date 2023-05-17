//
//  Logger.swift
//  ItsMEUtil
//
//  Created by Jaewon Yun on 2023/05/17.
//

import Foundation
import OSLog

public struct ItsMELogger {
    
    static var subsystem: String { "ItsME" }
    
    public static let standard: Logger = .init(subsystem: subsystem, category: "ItsME")
    public static let test: Logger = .init(subsystem: subsystem, category: "test")
    public static let network: Logger = .init(subsystem: subsystem, category: "network")
    public static let ui: Logger = .init(subsystem: subsystem, category: "ui")
}
