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
}
