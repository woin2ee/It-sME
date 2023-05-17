//
//  DateFormatter.swift
//  ItsMEUtil
//
//  Created by Jaewon Yun on 2023/05/17.
//

import Foundation

public struct ItsMEStandardDateFormatter {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    private init() {}
    
    public static func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    public static func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}

public struct ItsMESimpleDateFormatter {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy.MM.dd."
        return dateFormatter
    }()
    
    private init() {}
    
    static func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    public static func string(from date: Date?) -> String {
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
    
    public static func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}
