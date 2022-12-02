//
//  CVCard.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/22.
//

import Foundation
import UIKit
import SnapKit

class CVCard: UIView {
    
    lazy var cVTitle: UILabel = {
        let label = UILabel()
        label.text = "유재우 애플 아카데미 자소서(개발)"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    lazy var latestDate: UILabel = {
        let label = UILabel()
        label.text = "최근 수정일: 2022.12.31"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        return label
    }()
}

extension CVCard {
    
    override func layoutSubviews() {
        self.addSubview(cVTitle)
        self.addSubview(latestDate)
        
        cVTitle.snp.makeConstraints{ make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.top.equalTo(self.snp.top).offset(20)
            make.centerX.equalToSuperview().offset(5)
            //            make.centerY.equalToSuperview().offset(50)
        }
        
        
        latestDate.snp.makeConstraints{ make in
            make.width.equalTo(cVTitle.snp.width)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.centerX.equalTo(cVTitle.snp.centerX)
        }
    }
}

