//
//  UserInfoItem.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/17.
//

import Foundation

final class UserInfoItem: Decodable {
    let icon: UserInfoItemIcon
    let contents: String
    
    init(icon: UserInfoItemIcon, contents: String) {
        self.icon = icon
        self.contents = contents
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let iconString = try container.decode(String.self, forKey: .icon)
        self.icon = .init(rawValue: iconString) ?? .default
        self.contents = try container.decode(String.self, forKey: .contents)
    }
}

enum UserInfoItemIcon: String {
    case `default` = "default"
    case computer = "computer"
    case cake = "cake"
    case house = "house"
    case phone = "phone"
    case letter = "letter"
    
    var toEmoji: String {
        switch self {
        case .`default`:
            return "👤"
        case .computer:
            return "💻"
        case .cake:
            return "🎂"
        case .house:
            return "🏠"
        case .phone:
            return "📱"
        case .letter:
            return "✉️"
        }
    }
}

// MARK: - CodingKeys

extension UserInfoItem {
    
    enum CodingKeys: CodingKey {
        case icon
        case contents
    }
}
