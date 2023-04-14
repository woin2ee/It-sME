//
//  UIView+.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/17.
//

import Foundation
import UIKit

extension UIView {
    func circular(
        borderwidth: CGFloat = 2.0,
        bordercolor: CGColor = UIColor.mainColor.cgColor
    ) {
        self.layer.cornerRadius = (self.frame.size.width / 2.0)
        self.clipsToBounds = true
        
        self.layer.borderColor = bordercolor
        self.layer.borderWidth = borderwidth
    }
    
    /// 뷰 하단에 테두리를 추가하고 해당 레이어를 반환합니다.
    ///
    ///  - Parameters:
    ///     - width: 테두리의 두께
    ///     - color: 테두리의 색깔
    ///     - offset: 뷰 하단을 기준으로 얼마나 떨어져 있는지 나타내는 offset 값
    ///     - margin: 뷰 양옆으로 얼마나 떨어져 있는지 나타내는 값
    @discardableResult
    func addBottomBorder(width: CGFloat = 1.0, color: UIColor = .systemGray4, offset: CGFloat = 0, margin: CGFloat = 4.0) -> CALayer {
        let borderLayer: CALayer = .init()
        let margin: CGFloat = margin
        borderLayer.frame = .init(
            x: margin,
            y: self.bounds.height + offset,
            width: self.bounds.width - margin * 2,
            height: width
        )
        borderLayer.backgroundColor = color.cgColor
        self.layer.addSublayer(borderLayer)
        
        return borderLayer
    }
}
