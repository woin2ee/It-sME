//
//  UserBasicProfileInfo.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/17.
//

import Foundation

final class UserBasicProfileInfo: Codable {
    let icon: UserBasicProfileInfoIcon
    var contents: String
    
    init(icon: UserBasicProfileInfoIcon, contents: String) {
        self.icon = icon
        self.contents = contents
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let iconString = try container.decode(String.self, forKey: .icon)
        self.icon = .init(rawValue: iconString) ?? .default
        self.contents = try container.decode(String.self, forKey: .contents)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(icon.rawValue, forKey: .icon)
        try container.encode(contents, forKey: .contents)
    }
}

enum UserBasicProfileInfoIcon: String, CaseIterable{
    case `default` = "default"
    case computer = "computer"
    case cake = "cake"
    case house = "house"
    case phone = "phone"
    case letter = "letter"
    case email = "email"
    case telephone = "telephone"
    case book = "book"
    case pencil = "pencil"
    case thumbtack = "thumbtack"
    
    /// 현재 인스턴스에 할당된 이모지입니다.
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
        case .email:
            return "📧"
        case .telephone:
            return "📞"
        case .book:
            return "📚"
        case .pencil:
            return "✏️"
        case .thumbtack:
            return "📌"
        }
    }
    
    /// 지정된 `rawString` 에 해당하는 인스턴스를 만들어 반환합니다.
    ///
    /// 해당하는 `rawString` 이 없을 경우 `default(👤)` 인스턴스를 반환합니다.
    init(rawString: String) {
        if let instance = UserBasicProfileInfoIcon.init(rawValue: rawString) {
            self = instance
        } else {
            self = .default
        }
    }
}

// MARK: - CodingKeys

extension UserBasicProfileInfo {
    
    enum CodingKeys: CodingKey {
        case icon
        case contents
    }
}

// MARK: - Equatable

extension UserBasicProfileInfo: Equatable {
    
    static func == (lhs: UserBasicProfileInfo, rhs: UserBasicProfileInfo) -> Bool {
        lhs.icon == rhs.icon &&
        lhs.contents == rhs.contents
    }
}

extension UserBasicProfileInfo {
    
    static var empty: UserBasicProfileInfo {
        .init(icon: .default, contents: "")
    }
}
