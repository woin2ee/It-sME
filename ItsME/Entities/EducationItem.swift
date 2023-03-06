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
    
    var entranceDate: String {
        period.components(separatedBy: "-")[ifExists: 0]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    var entranceYear: Int {
        guard let year = entranceDate.components(separatedBy: ".")[ifExists: 0] else { return 0 }
        return Int.init(year) ?? 0
    }
    var entranceMonth: Int {
        guard let month = entranceDate.components(separatedBy: ".")[ifExists: 1] else { return 0 }
        return Int.init(month) ?? 0
    }
    var graduateDate: String {
        period.components(separatedBy: "-")[ifExists: 1]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    var graduateYear: Int {
        guard let year = graduateDate.components(separatedBy: ".")[ifExists: 0] else { return 0 }
        return Int.init(year) ?? 0
    }
    var graduateMonth: Int {
        guard let month = graduateDate.components(separatedBy: ".")[ifExists: 1] else { return 0 }
        return Int.init(month) ?? 0
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
