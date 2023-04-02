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
    
    func saveUserInfo(_ userInfo: UserInfo, byUID uid: String) -> Single<Void> {
        return .create { singleObserver in
            do {
                let data = try JSONEncoder().encode(userInfo)
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                self.database.userRef(uid).setValue(jsonObject)
                singleObserver(.success(()))
            } catch {
                singleObserver(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    func saveCurrentUserInfo(_ userInfo: UserInfo) -> Single<Void> {
        do {
            let uid = try self.uidRepository.get()
            return saveUserInfo(userInfo, byUID: uid)
        } catch {
            return .error(error)
        }
    }
}
