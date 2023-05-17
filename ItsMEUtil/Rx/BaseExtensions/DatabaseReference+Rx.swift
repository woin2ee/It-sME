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
    public var dataSnapshot: Single<DataSnapshot> {
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
    
    /// `setValue(_:)` 메소드의 `Reactive wrapper` 입니다.
    public func setValue(_ jsonObject: Any?) -> Single<DatabaseReference> {
        return .create { observer in
            Task {
                do {
                    let reference = try await self.base.setValue(jsonObject)
                    observer(.success(reference))
                } catch {
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// `removeValue()` 메소드의 `Reactive wrapper` 입니다.
    public func removeValue() -> Single<DatabaseReference> {
        return .create { observer in
            Task {
                do {
                    let reference = try await self.base.removeValue()
                    observer(.success(reference))
                } catch {
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
