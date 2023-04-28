//
//  DeleteAccountUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import Foundation

struct DeleteAccountUseCase {
    
    // MARK: Dependencies
    
    let userProfileRepository: UserProfileRepository
    let cvRepository: CVRepository
    let getAppleIDRefreshTokenFromKeychainUseCase: GetAppleIDRefreshTokenFromKeychainUseCase = .init()
    let revokeAppleIDTokenUseCase: RevokeAppleIDRefreshTokenUseCase = .init()
    
    init(userProfileRepository: UserProfileRepository, cvRepository: CVRepository) {
        self.userProfileRepository = userProfileRepository
        self.cvRepository = cvRepository
    }
}
