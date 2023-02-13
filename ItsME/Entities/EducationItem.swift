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
