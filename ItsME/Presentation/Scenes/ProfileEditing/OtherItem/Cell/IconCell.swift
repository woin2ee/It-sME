//
//  IconCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/06.
//

import SnapKit
import Then
import UIKit

final class IconCell: UICollectionViewCell {
    
    private lazy var iconLabel: UILabel = .init().then {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 20)
    }
    
    var icon: UserInfoItemIcon = .default {
        willSet {
            iconLabel.text = newValue.toEmoji
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.contentView.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
