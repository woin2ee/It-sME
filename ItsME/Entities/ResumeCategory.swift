//
//  ResumeCategory.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class ResumeCategory: Codable {
    var title: String
    var items: [ResumeItem]
    
    init(title: String, items: [ResumeItem]) {
        self.title = title
        self.items = items
    }
}

// MARK: - CodingKeys

extension ResumeCategory {
    enum CodingKeys: CodingKey {
    case title
    case items
    }
}

extension ResumeCategory {
    static var empty: ResumeCategory {
        .init(
            title: "",
            items: []
        )
    }
}
