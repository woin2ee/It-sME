//
//  CVInfo.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class CVInfo: Decodable {
    var title: String
    var resume: Resume
    var coverLetter: CoverLetter
    var lastModified: String
    
    init(title: String, resume: Resume, coverLetter: CoverLetter, lastModified: String) {
        self.title = title
        self.resume = resume
        self.coverLetter = coverLetter
        self.lastModified = lastModified
    }
}
