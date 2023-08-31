//
//  UserProfile.swift
//  It'sME
//
//  Created by Jaewon Yun on 2022/11/07.
//

import Foundation

final class UserProfile: Codable {
    var name: String
    var profileImageURL: String
    var birthday: UserBasicProfileInfo
    let address: UserBasicProfileInfo
    let phoneNumber: UserBasicProfileInfo
    let email: UserBasicProfileInfo
    var otherItems: [UserBasicProfileInfo]
    var educationItems: [Education]

    var defaultItems: [UserBasicProfileInfo] {
        [birthday, address, phoneNumber, email]
    }

    var allItems: [UserBasicProfileInfo] {
        defaultItems + otherItems
    }

    init(
        name: String,
        profileImageURL: String,
        birthday: UserBasicProfileInfo,
        address: UserBasicProfileInfo,
        phoneNumber: UserBasicProfileInfo,
        email: UserBasicProfileInfo,
        otherItems: [UserBasicProfileInfo],
        educationItems: [Education]
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
        self.birthday = try container.decode(UserBasicProfileInfo.self, forKey: .birthday)
        self.address = try container.decode(UserBasicProfileInfo.self, forKey: .address)
        self.phoneNumber = try container.decode(UserBasicProfileInfo.self, forKey: .phoneNumber)
        self.email = try container.decode(UserBasicProfileInfo.self, forKey: .email)
        do {
            self.otherItems = try container.decode([UserBasicProfileInfo].self, forKey: .otherItems)
        } catch {
            self.otherItems = []
        }
        do {
            self.educationItems = try container.decode([Education].self, forKey: .educationItems)
        } catch {
            self.educationItems = []
        }
    }
}

// MARK: - CodingKeys

extension UserProfile {

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

extension UserProfile: Equatable {

    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
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

extension UserProfile {

    static var empty: UserProfile {
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
