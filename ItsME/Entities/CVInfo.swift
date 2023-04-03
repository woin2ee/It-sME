//
//  CVInfo.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class CVInfo: Codable {
    var title: String
    var resume: Resume
    var coverLetter: CoverLetter
    var lastModified: String
    
    init(title: String,
         resume: Resume,
         coverLetter: CoverLetter,
         lastModified: String
    ) {
        self.title = title
        self.resume = resume
        self.coverLetter = coverLetter
        self.lastModified = lastModified
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.resume = try container.decode(Resume.self, forKey: .resume)
        self.coverLetter = try container.decode(CoverLetter.self, forKey: .coverLetter)
        self.lastModified = try container.decode(String.self, forKey: .lastModified)
    }
}

// MARK: - CodingKeys

extension CVInfo {
    
    enum CodingKeys: String, CodingKey {
    case title
    case resume
    case coverLetter
    case lastModified
    }
}

// MARK: - Equatable

extension CVInfo: Equatable {
    
    static func == (lhs: CVInfo, rhs: CVInfo) -> Bool {
        lhs.title == rhs.title &&
        lhs.resume == rhs.resume &&
        lhs.coverLetter == rhs.coverLetter &&
        lhs.lastModified == rhs.lastModified
    }
}

extension CVInfo {
    
    static var empty: CVInfo {
        .init(
            title: "",
            resume: .empty,
            coverLetter: .empty,
            lastModified: ""
        )
    }
}
