//
//  ResumeCategory.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class ResumeCategory {
    let title: String
    let items: [ResumeItem]
    
    init(title: String, items: [ResumeItem]) {
        self.title = title
        self.items = items
    }
}
