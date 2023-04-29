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
    /// 해당 뷰의 레이아웃이 완전히 잡히지 않은 상태에서 이 메소드를 호출하면 하단 테두리가 정상적으로 보이지 않을 수 있습니다. 일반적으로 `layoutSubviews()` 메소드를 오버라이딩하여 이 메소드를 호출합니다.
    ///
    ///  - Parameters:
    ///     - width: 테두리의 두께
    ///     - color: 테두리의 색깔
    ///     - offset: 뷰 하단을 기준으로 얼마나 떨어져 있는지 나타내는 offset 값
    ///     - margin: 뷰 양옆으로 얼마나 떨어져 있는지 나타내는 값. 만약 양수 값이면 하단 테두리 길이가 (margin*2) 만큼 짧아지고, 음수 값이면 길어집니다.
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
    
    /// 뷰의 스냅샷을 `UIImage` 객체로 변환합니다.
    /// - Returns: 변환한 이미지 객체입니다.
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        let image = renderer.image { imageRendererContext in
            self.layer.render(in: imageRendererContext.cgContext)
        }
        return image
    }
}
