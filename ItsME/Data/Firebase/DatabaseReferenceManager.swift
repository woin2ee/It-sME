//
//  DatabaseReferenceManager.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/24.
//

import FirebaseDatabase

struct DatabaseReferenceManager {
    
    static let shared: DatabaseReferenceManager = .init()
    
    private let dataBaseURL: String
    
    /// 실시간 데이터베이스의 최상위 Reference
    private let rootRef: DatabaseReference
    
    /// 모든 유저 정보의 Reference
    private let usersRef: DatabaseReference
    
    /// 모든 CV 정보의 Reference
    private let cvsRef: DatabaseReference
    
    private init() {
        guard
            let url = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist"),
            let dictionary = try? NSDictionary(contentsOf: url, error: ()),
            let dataBaseURL = dictionary["DATABASE_URL"] as? String
        else {
            preconditionFailure("실시간 데이터베이스의 URL 이 잘못되었습니다.")
        }
        
        self.dataBaseURL = dataBaseURL
        self.rootRef = Database.database(url: dataBaseURL).reference()
        self.usersRef = rootRef.child("users")
        self.cvsRef = rootRef.child("cvs")
    }
    
    /// 특정 유저 정보의 Reference
    func userRef(_ uid: String) -> DatabaseReference {
        usersRef.child(uid)
    }
    
    /// 특정 유저의 CV 목록 데이터 Reference
    func cvsRef(_ uid: String) -> DatabaseReference {
        cvsRef.child(uid)
    }
    
    @available(*, deprecated, renamed: "cvsRef(_:)")
    func cvRef(_ uid: String) -> DatabaseReference {
        cvsRef.child(uid)
    }
}
