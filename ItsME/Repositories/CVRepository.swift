//
//  CVRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/26.
//

import RxSwift

final class CVRepository {
    
    private let database = DatabaseReferenceManager.shared
    
    func getAllCV(byUID uid: String) -> Observable<[CVInfo]> {
        return database.cvRef(uid).rx.dataSnapshot
            .map { dataSnapshot in
                let jsonData = try JSONSerialization.data(withJSONObject: dataSnapshot.value as Any)
                let cvInfo = try JSONDecoder().decode([CVInfo].self, from: jsonData)
                return cvInfo
            }
    }
}
