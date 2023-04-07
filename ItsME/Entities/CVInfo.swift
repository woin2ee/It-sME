//
//  CVInfo.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class CVInfo: Codable {
    let uuid: String
    var title: String
    var resume: Resume
    var coverLetter: CoverLetter
    var lastModified: String
    
    init(
        uuid: String = UUID().uuidString,
        title: String,
        resume: Resume,
        coverLetter: CoverLetter,
        lastModified: String
    ) {
        self.uuid = uuid
        self.title = title
        self.resume = resume
        self.coverLetter = coverLetter
        self.lastModified = lastModified
    }
}

extension CVInfo {
    
    static var empty: CVInfo {
        return .init(
            title: "",
            resume: .empty,
            coverLetter: .empty,
            lastModified: ""
        )
    }
}
