//
//  CVRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import FirebaseAuth
import RxSwift

final class CVRepository {
    
    // MARK: Dependencies
    private let database = DatabaseReferenceManager.shared
    
    // MARK: API
    func getAllCV(byUID uid: String) -> Observable<[CVInfo]> {
        return database.cvRef(uid).rx.dataSnapshot
            .map { dataSnapshot in
                return try LoggedJsonDecoder.decode([CVInfo].self, withJSONObject: dataSnapshot.value)
            }
    }
    
    func getAllCVOfCurrentUser() -> Observable<[CVInfo]> {
        guard let uid = Auth.auth().currentUser?.uid else {
            return .empty()
        }
        return getAllCV(byUID: uid)
    }
    
    func saveCVInfo(_ cvInfo: CVInfo, byUID uid: String, index: Int) -> Observable<Void> {
        return .create { observer in
            do {
                let data = try JSONEncoder().encode(cvInfo)
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                self.database.cvRef("\(uid)/\(index)").setValue(jsonObject)
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func saveCurrentCVInfo(_ cvInfo: CVInfo, index: Int) -> Observable<Void> {
        guard let uid = Auth.auth().currentUser?.uid else {
            return .empty()
        }
        return saveCVInfo(cvInfo, byUID: uid, index: index)
    }
}

