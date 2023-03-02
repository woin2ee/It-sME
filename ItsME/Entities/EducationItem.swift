//
//  EducationItem.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/15.
//

import Foundation

final class EducationItem: Decodable {
    let period: String
    let title: String
    let description: String
    
    var entranceDate: String? {
        period.components(separatedBy: "-")[ifExists: 0]?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var graduateDate: String? {
        period.components(separatedBy: "-")[ifExists: 1]?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(period: String, title: String, description: String) {
        self.period = period
        self.title = title
        self.description = description
    }
}

// MARK: - Equatable

extension EducationItem: Equatable {
    
    static func == (lhs: EducationItem, rhs: EducationItem) -> Bool {
        lhs.period == rhs.period &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description
    }
}

extension EducationItem {
    
    static var empty: EducationItem {
        .init(period: "", title: "", description: "")
    }
}
