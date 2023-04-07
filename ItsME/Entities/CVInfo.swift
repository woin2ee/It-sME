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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.title = try container.decode(String.self, forKey: .title)
        
        do { self.resume = try container.decode(Resume.self, forKey: .resume) }
        catch { self.resume = .empty }
        
        do { self.coverLetter = try container.decode(CoverLetter.self, forKey: .coverLetter) }
        catch { self.coverLetter = .empty }
        
        self.lastModified = try container.decode(String.self, forKey: .lastModified)
    }
}

extension CVInfo {
    
    enum CodingKeys: CodingKey {
        case uuid
        case title
        case resume
        case coverLetter
        case lastModified
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
