//
//  CoverLetterItem.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class CoverLetterItem: Codable {
    var title: String
    var contents: String
    
    init(title: String, contents: String) {
        self.title = title
        self.contents = contents
    }
}

// MARK: - CodingKeys

extension CoverLetterItem {
    enum CodingKeys: CodingKey {
    case title
    case contents
    }
}

extension CoverLetterItem {
    static var empty: CoverLetterItem {
        .init(
            title: "",
            contents: ""
        )
    }
}
