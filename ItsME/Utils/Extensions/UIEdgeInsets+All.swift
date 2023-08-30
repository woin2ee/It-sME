//
//  UIEdgeInsets+All.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/28.
//

import UIKit

extension UIEdgeInsets {

    static func all(_ insetValue: CGFloat) -> Self {
        return .init(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue)
    }
}
