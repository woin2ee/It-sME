//
//  CVCard.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/22.
//

import Foundation
import UIKit
import SnapKit
import Then

final class CVCard: UIControl {
    
    // MARK: UI Objects
    
    lazy var cvTitleLabel: UILabel = .init().then {
        $0.text = ""
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    lazy var lastModifiedLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var contextMenuButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "ellipsis.circle.fill", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .white
        $0.showsMenuAsPrimaryAction = true
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.backgroundColor = .mainColor
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CVCard {
    
    private func setupConstraints() {
        self.addSubview(cvTitleLabel)
        cvTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(20)
            make.left.equalToSuperview().offset(10)
        }
        
        self.addSubview(contextMenuButton)
        contextMenuButton.snp.makeConstraints { make in
            make.left.equalTo(cvTitleLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.snp.top).offset(10)
            make.height.width.equalTo(50)
        }
        
        self.addSubview(lastModifiedLabel)
        lastModifiedLabel.snp.makeConstraints { make in
            make.width.centerX.equalTo(cvTitleLabel)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
