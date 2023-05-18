//
//  SaveProfileImageUseCaseMock.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/18.
//

@testable import ItsME
import FirebaseStorage
import RxSwift

struct SaveProfileImageUseCaseMock: SaveProfileImageUseCaseProtocol {
    
    var hasError: Bool
    let storageMetadata: StorageMetadata = .init()
    
    func execute(withImageData imageData: Data) -> Single<StorageMetadata> {
        if hasError {
            return .error(TestError.testError)
        } else {
            return .just(storageMetadata)
        }
    }
}
