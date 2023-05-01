//
//  TotalUserInfoItemStackView.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/08.
//

import UIKit

/// 좀 더 적절한 이름으로 사용할 수 있게 함
typealias UserInfoItemStackView = TotalUserInfoItemStackView

final class TotalUserInfoItemStackView: UIStackView {
    
    private var separatorLayers: [CALayer] = []
    
    var hasSeparator: Bool = false {
        didSet { self.setNeedsLayout() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.axis = .vertical
        let spacing: CGFloat = 8.0
        self.spacing = spacing
        self.alignment = .fill
        self.distribution = .equalSpacing
        self.directionalLayoutMargins = .init(top: spacing / 2, leading: spacing / 2, bottom: spacing / 2, trailing: spacing / 2)
        self.isLayoutMarginsRelativeArrangement = true
        
        bind(userInfoItems: [])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if hasSeparator {
            setSeparator()
        } else {
            removeAllSeparator()
        }
    }
    
    func bind(userInfoItems: [UserInfoItem]) {
        self.removeAllArrangedSubviews()
        
        userInfoItems.forEach { userInfoItem in
            let component = ProfileInfoComponent.init(userInfoItem: userInfoItem)
            self.addArrangedSubview(component)
        }
    }
}

// MARK: - Private Functions

private extension TotalUserInfoItemStackView {
    
    /// ArrangedSubviews 사이에 같은 간격으로 Separator 를 추가합니다.
    func setSeparator() {
        removeAllSeparator()
        
        let count = self.arrangedSubviews.count
        guard count > 0 else { return }
        
        for i in 0..<count - 1 {
            let separatorLayer = self.arrangedSubviews[i].addBottomBorder(offset: self.spacing / 2)
            separatorLayers.append(separatorLayer)
        }
    }
    
    /// 모든 Separator 를 삭제합니다.
    func removeAllSeparator() {
        self.separatorLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
        self.separatorLayers.removeAll()
    }
}
