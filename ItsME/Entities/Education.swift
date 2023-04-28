//
//  Education.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/15.
//

import Foundation

final class Education: Codable {
    let period: String
    let title: String
    let description: String
    
    /// 입학일을 나타내는 문자열
    var entranceDate: String? {
        period.components(separatedBy: "-")[ifExists: 0]?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var entranceYear: Int? {
        guard let year = entranceDate?.components(separatedBy: ".")[ifExists: 0] else { return nil }
        return Int.init(year)
    }
    var entranceMonth: Int? {
        guard let month = entranceDate?.components(separatedBy: ".")[ifExists: 1] else { return nil }
        return Int.init(month)
    }
    
    /// 졸업일을 나타내는 문자열
    var graduateDate: String? {
        period.components(separatedBy: "-")[ifExists: 1]?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var graduateYear: Int? {
        guard let year = graduateDate?.components(separatedBy: ".")[ifExists: 0] else { return nil }
        return Int.init(year)
    }
    var graduateMonth: Int? {
        guard let month = graduateDate?.components(separatedBy: ".")[ifExists: 1] else { return nil }
        return Int.init(month)
    }
    
    init(period: String, title: String, description: String) {
        self.period = period
        self.title = title
        self.description = description
    }
}

// MARK: - Equatable

extension Education: Equatable {
    
    static func == (lhs: Education, rhs: Education) -> Bool {
        lhs.period == rhs.period &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description
    }
}

extension Education {
    
    static var empty: Education {
        .init(period: "", title: "", description: "")
    }
}
