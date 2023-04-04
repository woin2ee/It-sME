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
