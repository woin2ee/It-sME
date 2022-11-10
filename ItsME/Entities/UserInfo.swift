//
//  UserInfo.swift
//  It'sME
//
//  Created by Jaewon Yun on 2022/11/07.
//

import Foundation

struct UserInfo {
    let name: String
    let profileImageURL: String
    let birthday: Date
    let address: String
    let phoneNumber: String
    let email: String
    let otherItems: [UserInfoItem]
}

struct UserInfoItem {
    let icon: UserInfoItemIcon?
    let contents: String
}

enum UserInfoItemIcon: String {
    case computer = "computer"
}
