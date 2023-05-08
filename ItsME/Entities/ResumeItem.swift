//
//  ResumeItem.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class ResumeItem: Codable {
    
    var period: String
    var title: String
    var secondTitle: String
    var description: String
    
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
    var endDate: String? {
        period.components(separatedBy: "-")[ifExists: 1]?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var endYear: Int? {
        guard let year = endDate?.components(separatedBy: ".")[ifExists: 0] else { return nil }
        return Int.init(year)
    }
    var endMonth: Int? {
        guard let month = endDate?.components(separatedBy: ".")[ifExists: 1] else { return nil }
        return Int.init(month)
    }
    
    init(period: String, title: String, secondTitle: String, description: String) {
        self.period = period
        self.title = title
        self.secondTitle = secondTitle
        self.description = description
    }
}

// MARK: - CodingKeys

extension ResumeItem {
    
    enum CodingKeys: CodingKey {
        case period
        case title
        case secondTitle
        case description
    }
}

// MARK: - Empty

extension ResumeItem {
    
    static var empty: ResumeItem {
        .init(period: "",
              title: "",
              secondTitle: "",
              description: "")
    }
}
