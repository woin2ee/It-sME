//
//  UserRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/13.
//

import RxSwift

final class UserRepository {
    
    // MARK: Dependencies
    
    private let database = DatabaseReferenceManager.shared
    private let uidRepository: UIDRepository = .shared
    
    // MARK: API
    
    func getUserInfo(byUID uid: String) -> Observable<UserInfo> {
        return database.userRef(uid).rx.dataSnapshot
            .map { dataSnapshot in
                return try LoggedJsonDecoder.decode(UserInfo.self, withJSONObject: dataSnapshot.value)
            }
    }
    
    func getCurrentUserInfo() -> Observable<UserInfo> {
        do {
            let uid = try self.uidRepository.get()
            return getUserInfo(byUID: uid)
        } catch {
            return .error(error)
        }
    }
}
