//
//  GetUserProfileUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/05/18.
//

import RxSwift

protocol GetUserProfileUseCaseProtocol {
    func execute() -> Single<UserProfile>
}

struct GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    
    // MARK: Shared Instance
    
    static let shared: GetUserProfileUseCase = .init(
        userProfileRepository: UserProfileRepository.shared
    )
    
    // MARK: Dependencies
    
    let userProfileRepository: UserProfileRepositoryProtocol
    
    func execute() -> Single<UserProfile> {
        return userProfileRepository.getUserProfile()
    }
}
