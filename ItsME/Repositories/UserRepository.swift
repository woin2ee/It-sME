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
                return try LoggedJsonDecoder.decode(UserInfo.self, withJSONObject: dataSnapshot.value)
            }
    }
}
