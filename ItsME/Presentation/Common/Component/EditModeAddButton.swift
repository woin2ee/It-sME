//
//  EditModeAddButton.swift
//  ItsME
//
//  Created by MacBook Air on 2023/02/27.
//

import UIKit
import Then
import SnapKit

class EditModeAddButton: UIButton {
    
    let borderLayer = CAShapeLayer()
    let cornerRadius: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureBorder()
    }
    
}

// MARK: - Private Functions
private extension EditModeAddButton {
    
    func configureBorder() {
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.secondaryLabel.cgColor
        borderLayer.lineDashPattern = [5, 5]
        borderLayer.lineWidth = 5.0
        borderLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.addSublayer(borderLayer)
    }
}
