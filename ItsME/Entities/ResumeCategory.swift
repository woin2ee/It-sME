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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        do {
            self.items = try container.decode([ResumeItem].self, forKey: .items)
        } catch {
            self.items = []
        }
    }
}

// MARK: - CodingKeys

extension ResumeCategory {
    
    enum CodingKeys: CodingKey {
        case title
        case items
    }
}

// MARK: - Empty

extension ResumeCategory {
    
    static var empty: ResumeCategory {
        .init(
            title: "",
            items: []
        )
    }
}
