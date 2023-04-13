//
//  CVRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import FirebaseAuth
import RxSwift

final class CVRepository {
    
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
    
    func saveCVTitle(_ cvTitle: String, lastModified: String, uuid: String) -> Observable<Void> {
        guard let uid = Auth.auth().currentUser?.uid else {
            return .empty()
        }
        return .create { observer in
            self.database.cvsRef(uid)
                .child(uuid).child(CVInfo.CodingKeys.title.rawValue).setValue(cvTitle)
            self.database.cvsRef(uid)
                .child(uuid).child(CVInfo.CodingKeys.lastModified.rawValue).setValue(lastModified)
            observer.onNext(())
            observer.onCompleted()
            
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
}

