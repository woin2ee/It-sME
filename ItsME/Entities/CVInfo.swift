//
//  CVInfo.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class CVInfo: Decodable {
    let title: String
    let resume: Resume
    let coverLetter: CoverLetter
    let lastModified: String
    
    init(title: String, resume: Resume, coverLetter: CoverLetter, lastModified: String) {
        self.title = title
        self.resume = resume
        self.coverLetter = coverLetter
        self.lastModified = lastModified
    }
}
