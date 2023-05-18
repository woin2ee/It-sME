//
//  SaveUserProfileUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/05/18.
//

import RxSwift

protocol SaveUserProfileUseCaseProtocol {
    func execute(with userProfile: UserProfile) -> Single<Void>
}

struct SaveUserProfileUseCase: SaveUserProfileUseCaseProtocol {
    
    // MARK: Shared Instance
    
    static let shared: SaveUserProfileUseCase = .init(
        userProfileRepository: UserProfileRepository.shared
    )
    
    // MARK: Dependencies
    
    let userProfileRepository: UserProfileRepositoryProtocol
    
    func execute(with userProfile: UserProfile) -> Single<Void> {
        return userProfileRepository.saveUserProfile(userProfile)
    }
}
