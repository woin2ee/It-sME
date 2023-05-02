//
//  CGPoint+.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/29.
//

import Foundation

extension CGPoint {
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return .init(
            x: left.x - right.x,
            y: left.y - right.y
        )
    }
}
