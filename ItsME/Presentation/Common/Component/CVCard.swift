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

class CVCard: UIControl {
    
    lazy var cvTitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var latestDate: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var menuButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "ellipsis.circle.fill", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .white
    }
}

extension CVCard {
    
    override func layoutSubviews() {
        
        
        self.addSubview(cvTitle)
        cvTitle.snp.makeConstraints{ make in
            make.top.equalTo(self.snp.top).offset(20)
            make.left.equalToSuperview().offset(10)
        }
        
        self.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.left.equalTo(cvTitle.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.snp.top).offset(10)
            make.height.width.equalTo(50)
        }
        
        self.addSubview(latestDate)
        latestDate.snp.makeConstraints{ make in
            make.width.equalTo(cvTitle.snp.width)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.centerX.equalTo(cvTitle.snp.centerX)
        }
    }
}

