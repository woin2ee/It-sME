//
//  SaveProfileImageUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/05/08.
//

import FirebaseStorage
import RxSwift

protocol SaveProfileImageUseCaseProtocol {
    func execute(withImageData imageData: Data) -> Single<StorageMetadata>
}

struct SaveProfileImageUseCase: SaveProfileImageUseCaseProtocol {

    // MARK: Shared Instance

    static let shared: SaveProfileImageUseCase = .init()

    // MARK: Execute

    func execute(withImageData imageData: Data) -> Single<StorageMetadata> {
        do {
            let path = try StoragePath().userProfileImage
            return Storage.storage().reference().child(path).rx.putData(imageData)
        } catch {
            return .error(error)
        }
    }
}
