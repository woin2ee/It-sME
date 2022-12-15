//
//  TotalUserInfoItemStackView.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/08.
//

import UIKit

final class TotalUserInfoItemStackView: UIStackView {
    
    private let userInfoItems: [UserInfoItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGray6
        
        self.isUserInteractionEnabled = false
        self.axis = .vertical
        self.spacing = 4
        self.alignment = .fill
        self.distribution = .fillEqually
        
        bind(userInfoItems: userInfoItems)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(userInfoItems: [UserInfoItem]) {
        removeAllArrangedSubviews()
        userInfoItems.forEach { userInfoItem in
            let component = ProfileInfoComponent.init(userInfoItem: userInfoItem)
            self.addArrangedSubview(component)
        }
    }
    
    private func removeAllArrangedSubviews() {
        let removedSubviews = self.arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
