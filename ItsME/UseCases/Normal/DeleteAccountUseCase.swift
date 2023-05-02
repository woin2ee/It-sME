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
    let getAppleIDRefreshTokenFromKeychainUseCase: GetAppleIDRefreshTokenFromKeychainUseCase
    let revokeAppleIDTokenUseCase: RevokeAppleIDRefreshTokenUseCase
    let getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCase
    
    init(
        userProfileRepository: UserProfileRepository,
        cvRepository: CVRepository,
        getAppleIDRefreshTokenFromKeychainUseCase: GetAppleIDRefreshTokenFromKeychainUseCase,
        revokeAppleIDTokenUseCase: RevokeAppleIDRefreshTokenUseCase,
        getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCase
    ) {
        self.userProfileRepository = userProfileRepository
        self.cvRepository = cvRepository
        self.getAppleIDRefreshTokenFromKeychainUseCase = getAppleIDRefreshTokenFromKeychainUseCase
        self.revokeAppleIDTokenUseCase = revokeAppleIDTokenUseCase
        self.getCurrentAuthProviderIDUseCase = getCurrentAuthProviderIDUseCase
    }
}
