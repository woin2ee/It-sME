//
//  ItsMEUtils.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/12.
//

import Foundation

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw ItsMEError.castingFailed(object: object, targetType: resultType)
    }
    return returnValue
}

func unwrapOrThrow<T>(_ optionalValue: T?) throws -> T {
    guard let unwrappedValue = optionalValue else {
        throw ItsMEError.nilValue(object: optionalValue)
    }
    return unwrappedValue
}

func closestValue<T: BinaryFloatingPoint>(_ target: T, in arr: [T]) -> T? {
    if arr.isEmpty { return nil }
    
    let sorted = arr.sorted()
    
    let over = sorted.first(where: { $0 >= target }) ?? .infinity
    let under = sorted.last(where: { $0 <= target }) ?? -.infinity
    
    let diffOver = over - target
    let diffUnder = target - under
    return (diffOver < diffUnder) ? over : under
}

struct ItsMEStandardDateFormatter {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    private init() {}
    
    static func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}

struct ItsMESimpleDateFormatter {
    
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
}
