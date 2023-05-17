//
//  CVRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import FirebaseAuth
import RxSwift

protocol CVRepositoryProtocol {
    
    func getAllCV() -> Single<[CVInfo]>
    
    func saveCVInfo(_ cvInfo: CVInfo) -> Single<Void>
    
    func saveCVTitle(_ cvTitle: String, lastModified: String, uuid: String) -> Single<Void>
    
    func removeCV(by uuid: String) -> Single<Void>
    
    /// 데이터베이스에 저장된 현재 사용자의 이력서 정보를 삭제합니다.
    func deleteAllCVs() -> Completable
}

final class CVRepository: CVRepositoryProtocol {
    
    // MARK: Make to Singleton
    
    static let shared: CVRepository = .init()
    
    private init() {
        self.database = .shared
    }
    
    // MARK: Dependencies
    
    private let database: DatabaseReferenceManager
    
    // MARK: API
    
    func getAllCV() -> Single<[CVInfo]> {
        let source = Auth.auth().rx.currentUser
            .map { $0.uid }
            .flatMap { self.database.cvsRef($0).rx.dataSnapshot }
            .map { try castOrThrow([String: Any].self, $0.value as Any) }
            .map { $0.map { key, value in
                return value
            }}
            .map { jsonObject in
                return try LoggedJsonDecoder.decode([CVInfo].self, withJSONObject: jsonObject)
            }
        return source
    }
    
    func saveCVInfo(_ cvInfo: CVInfo) -> Single<Void> {
        let source = Auth.auth().rx.currentUser
            .map { $0.uid }
            .flatMap { uid in
                let data = try JSONEncoder().encode(cvInfo)
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                return self.database.cvsRef(uid).child(cvInfo.uuid).rx.setValue(jsonObject)
                    .mapToVoid()
            }
        return source
    }
    
    func saveCVTitle(_ cvTitle: String, lastModified: String, uuid: String) -> Single<Void> {
        guard let uid = Auth.auth().currentUser?.uid else {
            return .error(AuthErrorCode(.nullUser))
        }
        return .create { observer in
            self.database.cvsRef(uid)
                .child(uuid).child(CVInfo.CodingKeys.title.rawValue).setValue(cvTitle)
            self.database.cvsRef(uid)
                .child(uuid).child(CVInfo.CodingKeys.lastModified.rawValue).setValue(lastModified)
            observer(.success(()))
            
            return Disposables.create()
        }
    }
    
    func removeCV(by uuid: String) -> Single<Void> {
        let source = Auth.auth().rx.currentUser
            .map { $0.uid }
            .flatMap { uid in
                return self.database.cvsRef(uid).child(uuid).rx.removeValue()
                    .mapToVoid()
            }
        return source
    }
    
    func deleteAllCVs() -> Completable {
        let source = Auth.auth().rx.currentUser
            .map(\.uid)
            .flatMap { self.database.cvsRef($0).rx.removeValue() }
            .asCompletable()
        return source
    }
}

