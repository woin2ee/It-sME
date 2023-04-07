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
    
    func getUserInfo(byUID uid: String) -> Observable<UserInfo> {
        return database.userRef(uid).rx.dataSnapshot
            .map { dataSnapshot in
                return try LoggedJsonDecoder.decode(UserInfo.self, withJSONObject: dataSnapshot.value)
            }
    }
    
    func getCurrentUserInfo() -> Observable<UserInfo> {
        guard let uid = Auth.auth().currentUser?.uid else {
            return .empty()
        }
        return getUserInfo(byUID: uid)
    }
    
    func saveUserInfo(_ userInfo: UserInfo, byUID uid: String) -> Observable<Void> {
        return .create { observer in
            do {
                let data = try JSONEncoder().encode(userInfo)
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                self.database.userRef(uid).setValue(jsonObject)
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func saveCurrentUserInfo(_ userInfo: UserInfo) -> Observable<Void> {
        guard let uid = Auth.auth().currentUser?.uid else {
            return .empty()
        }
        return saveUserInfo(userInfo, byUID: uid)
    }
}
