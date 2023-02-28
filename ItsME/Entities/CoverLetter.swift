//
//  CoverLetter.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class CoverLetter: Decodable {
    var items: [CoverLetterItem]
    
    init(items: [CoverLetterItem]) {
        self.items = items
    }
}
