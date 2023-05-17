//
//  StorageReference+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/04.
//

import FirebaseStorage
import RxSwift

extension Reactive where Base: StorageReference {
    
    public func getData(maxSize: Int64 = 3 * 1024 * 1024) -> Single<Data> {
        return .create { observer in
            let task = self.base.getData(maxSize: maxSize) { result in
                switch result {
                case .success(let data):
                    observer(.success(data))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    public func putData(_ data: Data) -> Single<StorageMetadata> {
        return .create { observer in
            let task = self.base.putData(data) { result in
                switch result {
                case .success(let metaData):
                    observer(.success(metaData))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    public func delete() -> Completable {
        return .create { observer in
            Task {
                do {
                    try await self.base.delete()
                    observer(.completed)
                } catch {
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
