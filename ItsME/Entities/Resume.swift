//
//  Resume.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class Resume: Codable {
    
    var category: [ResumeCategory]
    
    init(category: [ResumeCategory]) {
        self.category = category
    }
}

// MARK: - CodingKeys

extension Resume {
    
    enum CodingKeys: CodingKey {
        case category
    }
}

// MARK: - Empty

extension Resume {
    
    static var empty: Resume {
        .init(category: [])
    }
}
