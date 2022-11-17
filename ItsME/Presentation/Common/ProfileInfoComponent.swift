//
//  ProfileInfoComponent.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/17.
//

import Foundation
import UIKit
import SnapKit

class ProfileInfoComponent: UIStackView {
    var userInfoItem: UserInfoItem
    
    init(userInfoItem: UserInfoItem) {
        self.userInfoItem = userInfoItem
        super.init(frame: .zero)
    }
    
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
