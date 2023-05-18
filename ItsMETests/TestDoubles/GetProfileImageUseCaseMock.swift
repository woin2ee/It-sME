//
//  GetProfileImageUseCaseMock.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/18.
//

@testable import ItsME
import RxSwift

struct GetProfileImageUseCaseMock: GetProfileImageUseCaseProtocol {
    
    var hasError: Bool
    let profileImageData: Data = UIImage.defaultProfileImage.jpegData(compressionQuality: 1.0)!
    
    func execute(withStoragePath path: String) -> Single<Data> {
        if hasError {
            return .error(TestError.testError)
        } else {
            return .just(profileImageData)
        }
    }
}
