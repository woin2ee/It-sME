//
//  AddCVButton.swift
//  ItsME
//
//  Created by MacBook Air on 2023/04/04.
//

import UIKit
import SFSafeSymbols
import SnapKit
import Then

class AddCVButton: UIControl {

    let borderLayer = CAShapeLayer()

    let cornerRadius = 10.0

    lazy var addImageView: UIImageView = .init().then {
        $0.image =  UIImage(systemSymbol: .plusRectanglePortraitFill)
    }

    lazy var titleLabel = UILabel().then {
        $0.text = "이력서 추가"
        $0.textColor = .mainColor
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 30, weight: .bold)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .systemBackground
        self.tintColor = .mainColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        setupConstraints()
        configureBorder()
    }
}

// MARK: - Methods

extension AddCVButton {

    private func setupConstraints() {
        self.addSubview(addImageView)
        addImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(addImageView.snp.width)
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(addImageView)
            make.top.equalTo(addImageView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalTo(addImageView)
        }
    }

    private func configureBorder() {
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.mainColor.cgColor
        borderLayer.lineDashPattern = [10, 5]
        let lineWidth: CGFloat = 5.0
        borderLayer.lineWidth = lineWidth
        borderLayer.path = UIBezierPath(
            roundedRect: self.bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2),
            cornerRadius: 10
        ).cgPath
        self.layer.addSublayer(borderLayer)
    }
}
