//
//  ResumeItem.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class ResumeItem: Decodable {
    var period: String
    var title: String
    var secondTitle: String
    var description: String
    
    init(period: String, title: String, secondTitle: String, description: String) {
        self.period = period
        self.title = title
        self.secondTitle = secondTitle
        self.description = description
    }
}
