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
    
    let fontSize: CGFloat = 30
    let mainColor: UIColor = .mainColor
    let borderLayer = CAShapeLayer()
    let cornerRadius: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSymbolImage()
        configureTitle()
        
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureColor()
    }
}

// MARK: - Private Functions
private extension EditModeAddButton {
    
    func configureColor() {
        setBackgroundColor(.systemBackground, for: .normal)
        setBackgroundColor(.systemGray4, for: .highlighted)
        self.tintColor = mainColor
    }
    
    func configureSymbolImage() {
        let configuration: UIImage.SymbolConfiguration = .init(pointSize: fontSize, weight: .heavy, scale: .default)
        let symbolImage: UIImage? = .init(systemName: "plus.rectangle.fill", withConfiguration: configuration)
        self.setImage(symbolImage, for: .normal)
        self.setImage(symbolImage, for: .highlighted)
    }
    
    func configureTitle() {
        let title: NSAttributedString = .init(string: "항목 추가", attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .heavy)])
        self.setAttributedTitle(title, for: .normal)
        self.setTitleColor(mainColor, for: .normal)
    }
    
    func configureBorder() {
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.secondaryLabel.cgColor
        borderLayer.lineDashPattern = [5, 5]
        borderLayer.lineWidth = 5.0
        borderLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.addSublayer(borderLayer)
    }
}

