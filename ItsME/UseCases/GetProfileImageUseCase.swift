//
//  GetProfileImageUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/05/08.
//

import FirebaseStorage
import RxSwift

protocol GetProfileImageUseCaseProtocol {
    /// <#Description#>
    /// - Parameter path: `Firebase Storage` 의 리소스를 가리키는 full path
    /// - Returns: <#description#>
    func execute(withStoragePath path: String) -> Single<Data>
}

struct GetProfileImageUseCase: GetProfileImageUseCaseProtocol {
    
    // MARK: Shared Instance
    
    static let shared: GetProfileImageUseCase = .init()
    
    // MARK: Execute
    
    func execute(withStoragePath path: String) -> Single<Data> {
        return Storage.storage().reference().child(path).rx.getData().map { $0 }
    }
}
