//
//  Resume.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class Resume: Decodable {
    var category: [ResumeCategory]
    
    init(category: [ResumeCategory]) {
        self.category = category
    }
}
