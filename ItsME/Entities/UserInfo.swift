//
//  UserInfo.swift
//  It'sME
//
//  Created by Jaewon Yun on 2022/11/07.
//

import Foundation

final class UserInfo: Codable {
    var name: String
    var profileImageURL: String
    var birthday: UserInfoItem
    let address: UserInfoItem
    let phoneNumber: UserInfoItem
    let email: UserInfoItem
    var otherItems: [UserInfoItem]
    var educationItems: [EducationItem]

    var defaultItems: [UserInfoItem] {
        [birthday, address, phoneNumber, email]
    }
    
    var allItems: [UserInfoItem] {
        defaultItems + otherItems
    }
    
    init(
        name: String,
        profileImageURL: String,
        birthday: UserInfoItem,
        address: UserInfoItem,
        phoneNumber: UserInfoItem,
        email: UserInfoItem,
        otherItems: [UserInfoItem],
        educationItems: [EducationItem]
    ) {
        self.name = name
        self.profileImageURL = profileImageURL
        self.birthday = birthday
        self.address = address
        self.phoneNumber = phoneNumber
        self.email = email
        self.otherItems = otherItems
        self.educationItems = educationItems
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.profileImageURL = try container.decode(String.self, forKey: .profileImageURL)
        self.birthday = try container.decode(UserInfoItem.self, forKey: .birthday)
        self.address = try container.decode(UserInfoItem.self, forKey: .address)
        self.phoneNumber = try container.decode(UserInfoItem.self, forKey: .phoneNumber)
        self.email = try container.decode(UserInfoItem.self, forKey: .email)
        self.otherItems = try container.decode([UserInfoItem].self, forKey: .otherItems)
        self.educationItems = try container.decode([EducationItem].self, forKey: .educationItems)
    }
}

// MARK: - CodingKeys

extension UserInfo {
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImageURL
        case birthday
        case address
        case phoneNumber
        case email
        case otherItems
        case educationItems
    }
}

// MARK: - Equatable

extension UserInfo: Equatable {
    
    static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        lhs.name == rhs.name &&
        lhs.profileImageURL == rhs.profileImageURL &&
        lhs.birthday == rhs.birthday &&
        lhs.address == rhs.address &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.email == rhs.email &&
        lhs.otherItems == rhs.otherItems &&
        lhs.educationItems == rhs.educationItems
    }
}

extension UserInfo {
    
    static var empty: UserInfo {
        .init(
            name: "",
            profileImageURL: "",
            birthday: .empty,
            address: .empty,
            phoneNumber: .empty,
            email: .empty,
            otherItems: [],
            educationItems: []
        )
    }
}
