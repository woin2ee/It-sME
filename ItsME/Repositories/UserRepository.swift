//
//  UserRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/13.
//

import RxSwift

final class UserRepository {
    
    private let database = DatabaseReferenceManager.shared
    
    func getUserInfo(byUID uid: String) -> Observable<UserInfo> {
        return database.userRef(uid).rx.dataSnapshot
            .map { dataSnapshot in
                let jsonData = try JSONSerialization.data(withJSONObject: dataSnapshot.value as Any)
                let userInfo = try JSONDecoder().decode(UserInfo.self, from: jsonData)
                return userInfo
            }
    }
}
