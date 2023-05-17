//
//  Calendar+Current.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/07.
//

import Foundation

extension Calendar {
    
    public var currentYear: Int {
        self.component(.year, from: .now)
    }
    
    public var currentMonth: Int {
        self.component(.month, from: .now)
    }
    
    public var currentDay: Int {
        self.component(.day, from: .now)
    }
}
