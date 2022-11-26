//
//  CVInfo.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import Foundation

final class CVInfo {
    let title: String
    let resume: Resume
    let coverLetter: CoverLetter
    
    init(title: String, resume: Resume, coverLetter: CoverLetter) {
        self.title = title
        self.resume = resume
        self.coverLetter = coverLetter
    }
}
