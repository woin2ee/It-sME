//
//  ResumeCategory.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class ResumeCategory: Decodable {
    var title: String
    var items: [ResumeItem]
    
    init(title: String, items: [ResumeItem]) {
        self.title = title
        self.items = items
    }
}
