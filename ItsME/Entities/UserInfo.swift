//
//  UserInfo.swift
//  It'sME
//
//  Created by Jaewon Yun on 2022/11/07.
//

import Foundation

final class UserInfo: Decodable {
    let name: String
    let profileImageURL: String
    let birthday: String
    let address: String
    let phoneNumber: String
    let email: String
    let otherItems: [UserInfoItem]
    
    init(
        name: String,
        profileImageURL: String,
        birthday: String,
        address: String,
        phoneNumber: String,
        email: String,
        otherItems: [UserInfoItem] = []
    ) {
        self.name = name
        self.profileImageURL = profileImageURL
        self.birthday = birthday
        self.address = address
        self.phoneNumber = phoneNumber
        self.email = email
        self.otherItems = otherItems
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.profileImageURL = try container.decode(String.self, forKey: .profileImageURL)
        self.birthday = try container.decode(String.self, forKey: .birthday)
        self.address = try container.decode(String.self, forKey: .address)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.email = try container.decode(String.self, forKey: .email)
        self.otherItems = try container.decode([UserInfoItem].self, forKey: .otherItems)
    }
}

// MARK: - CodingKeys

extension UserInfo {
    
    enum CodingKeys: CodingKey {
        case name
        case profileImageURL
        case birthday
        case address
        case phoneNumber
        case email
        case otherItems
    }
}
