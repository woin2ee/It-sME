//
//  DeleteAccountUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import Foundation

struct DeleteAccountUseCase {

    static let shared: DeleteAccountUseCase = .init(
        userProfileRepository: .shared,
        cvRepository: .shared,
        getAppleIDRefreshTokenFromKeychainUseCase: .shared,
        revokeAppleIDTokenUseCase: .shared,
        getCurrentAuthProviderIDUseCase: .shared
    )

    // MARK: Dependencies

    let userProfileRepository: UserProfileRepository
    let cvRepository: CVRepository
    let getAppleIDRefreshTokenFromKeychainUseCase: GetAppleIDRefreshTokenFromKeychainUseCase
    let revokeAppleIDTokenUseCase: RevokeAppleIDRefreshTokenUseCase
    let getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCase

    private init(
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
