//
//  AddCVButton.swift
//  ItsME
//
//  Created by MacBook Air on 2023/04/04.
//

import UIKit
import SnapKit
import Then

class AddCVButton: UIControl {
    
    let borderLayer = CAShapeLayer()
    
    let cornerRadius = 10.0
    
    lazy var addImage: UIImageView = .init()
    
    lazy var title = UILabel().then {
        $0.text = ""
    }
}

// MARK: - Private Function
extension AddCVButton {
    
    override func layoutSubviews() {
        
        configureBorder()
        
        self.addSubview(addImage)
        addImage.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(addImage.snp.width)
            make.top.equalTo(self.snp.top).offset(20)
            make.centerX.equalToSuperview().offset(5)
        }
        
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.width.equalTo(addImage)
            make.top.equalTo(addImage.snp.bottom).offset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.centerX.equalTo(addImage.snp.centerX)
        }
    }
    
    func configureBorder() {
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.mainColor.cgColor
        borderLayer.lineDashPattern = [10, 5]
        borderLayer.lineWidth = 5
        borderLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 10).cgPath
        self.layer.addSublayer(borderLayer)
    }
}
