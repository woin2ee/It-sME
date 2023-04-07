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
    var dataSnapshot: Observable<DataSnapshot> {
        return Observable.create { observer in
            
            self.base.getData { error, dataSnapshot in
                guard let dataSnapshot = dataSnapshot else {
                    observer.onError(error ?? RxError.noElements)
                    return
                }
                
                observer.onNext(dataSnapshot)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
