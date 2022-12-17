//
//  UIStackView+.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/15.
//

import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        let removedSubviews = self.arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
