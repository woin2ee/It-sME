//
//  UserProfileRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/13.
//

import FirebaseAuth
import RxSwift

final class UserProfileRepository {
    
    // MARK: Make to Singleton
    
    static let shared: UserProfileRepository = .init()
    
    private init() {
        self.database = .shared
    }
    
    // MARK: Dependencies
    
    private let database: DatabaseReferenceManager
    
    // MARK: API
    
    var hasUserInfo: Single<Bool> {
        let source = Auth.auth().rx.currentUser
            .map { $0.uid }
            .flatMap { self.database.userRef($0).rx.dataSnapshot }
            .map { $0.exists() }
        return source
    }
    
    func getUserInfo() -> Single<UserProfile> {
        let source = Auth.auth().rx.currentUser
            .map { $0.uid }
            .flatMap { self.database.userRef($0).rx.dataSnapshot }
            .map { dataSnapshot in
                return try LoggedJsonDecoder.decode(UserProfile.self, withJSONObject: dataSnapshot.value)
            }
        return source
    }
    
    func saveUserInfo(_ userInfo: UserProfile) -> Single<Void> {
        let source = Auth.auth().rx.currentUser
            .map { $0.uid }
            .flatMap { uid in
                let data = try JSONEncoder().encode(userInfo)
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                return self.database.userRef(uid).rx.setValue(jsonObject).mapToVoid()
            }
        return source
    }
    
    /// 데이터베이스에 저장된 현재 사용자의 프로필 정보를 삭제합니다.
    func deleteUserInfo() -> Completable {
        let source = Auth.auth().rx.currentUser
            .map(\.uid)
            .flatMap { self.database.userRef($0).rx.removeValue() }
            .asCompletable()
        return source
    }
    
    /// 현재 사용자의 계정을 Firebase Authentication 에서 삭제합니다.
    func deleteUser() -> Single<Void> {
        let source = Auth.auth().rx.currentUser
            .flatMap { user -> Single<Void> in
                return .create { observer in
                    Task {
                        do {
                            try await user.delete()
                            observer(.success(()))
                        } catch {
                            observer(.failure(error))
                        }
                    }
                    return Disposables.create()
                }
            }
        return source
    }
}
