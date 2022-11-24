//
//  UserInfoItem.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/17.
//

import Foundation

struct UserInfoItem {
    let icon: UserInfoItemIcon
    let contents: String
}

enum UserInfoItemIcon: String {
    case `default` = "default"
    case computer = "computer"
}
