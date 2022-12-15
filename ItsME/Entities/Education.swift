//
//  Education.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/15.
//

import Foundation

final class Education: Decodable {
    let period: String
    let title: String
    let description: String
    
    init(period: String, title: String, description: String) {
        self.period = period
        self.title = title
        self.description = description
    }
}
