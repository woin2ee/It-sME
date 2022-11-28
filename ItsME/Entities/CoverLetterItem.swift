//
//  CoverLetterItem.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class CoverLetterItem: Decodable {
    let title: String
    let contents: String
    
    init(title: String, contents: String) {
        self.title = title
        self.contents = contents
    }
}
