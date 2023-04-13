//
//  UserRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/13.
//

import FirebaseAuth
import RxSwift

final class UserRepository {
    
    // MARK: Make to Singleton
    
    static let shared: UserRepository = .init()
    
    private init() {
        self.database = .shared
    }
    
    // MARK: Dependencies
    
    private let database: DatabaseReferenceManager
    
    // MARK: API
    
    func getUserInfo() -> Single<UserInfo> {
        let source = Auth.auth().rx.currentUser
            .map { $0.uid }
            .flatMap { self.database.userRef($0).rx.dataSnapshot }
            .map { dataSnapshot in
                return try LoggedJsonDecoder.decode(UserInfo.self, withJSONObject: dataSnapshot.value)
            }
        return source
    }
    
    func saveUserInfo(_ userInfo: UserInfo) -> Single<Void> {
        let source = Auth.auth().rx.currentUser
            .map { $0.uid }
            .flatMap { uid in
                let data = try JSONEncoder().encode(userInfo)
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                return self.database.userRef(uid).rx.setValue(jsonObject).mapToVoid()
            }
        return source
    }
}
