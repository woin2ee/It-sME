//
//  ResumeItem.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class ResumeItem: Decodable {
    var period: String
    var title: String
    var secondTitle: String
    var description: String
    
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
    var endDate: String {
        period.components(separatedBy: "-")[ifExists: 1]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    var endYear: Int {
        guard let year = endDate.components(separatedBy: ".")[ifExists: 0] else { return 0 }
        return Int.init(year) ?? 0
    }
    var endMonth: Int {
        guard let month = endDate.components(separatedBy: ".")[ifExists: 1] else { return 0 }
        return Int.init(month) ?? 0
    }
    
    init(period: String, title: String, secondTitle: String, description: String) {
        self.period = period
        self.title = title
        self.secondTitle = secondTitle
        self.description = description
    }
}
