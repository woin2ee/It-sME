//
//  DatabaseReferenceManager.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/24.
//

import FirebaseDatabase

final class DatabaseReferenceManager {
    
    static let shared: DatabaseReferenceManager = .init()
    
    private let dataBaseURL: String
    
    /// 실시간 데이터베이스의 최상위 Reference
    private let rootRef: DatabaseReference
    
    /// 모든 유저 정보의 Reference
    private let usersRef: DatabaseReference
    
    /// 모든 CV 정보의 Reference
    private let cvsRef: DatabaseReference
    
    private init() {
        self.dataBaseURL = "https://itsme-30e1a-default-rtdb.asia-southeast1.firebasedatabase.app"
        self.rootRef = Database.database(url: dataBaseURL).reference()
        self.usersRef = rootRef.child("users")
        self.cvsRef = rootRef.child("cvs")
    }
    
    /// 특정 유저 정보의 Reference
    func userRef(_ uid: String) -> DatabaseReference {
        usersRef.child(uid)
    }
    
    func cvRef(_ uid: String) -> DatabaseReference {
        cvsRef.child(uid)
    }
}
