//
//  CoverLetter.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class CoverLetter: Codable {
    var items: [CoverLetterItem]
    
    init(items: [CoverLetterItem]) {
        self.items = items
    }
}

// MARK: - CodingKeys

extension CoverLetter {
    enum CodingKeys: CodingKey {
    case items
    }
}

// MARK: - Equatable

extension CoverLetter: Equatable {
    
    static func == (lhs: CoverLetter, rhs: CoverLetter) -> Bool {
        lhs.items == rhs.items
    }
}

extension CoverLetter {
    static var empty: CoverLetter {
        .init(items: [])
        
    }
}
