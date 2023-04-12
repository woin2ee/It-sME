//
//  DatabaseReference+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/24.
//

import RxSwift
import FirebaseDatabase

extension Reactive where Base: DatabaseReference {
    
    /// Observable sequence of DataSnapshot
    var dataSnapshot: Single<DataSnapshot> {
        return .create { observer in
            Task {
                do {
                    let dataSnapshot = try await self.base.getData()
                    observer(.success(dataSnapshot))
                } catch {
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
