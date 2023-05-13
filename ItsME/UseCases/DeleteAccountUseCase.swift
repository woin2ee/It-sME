//
//  DeleteAccountUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import FirebaseAuth
import FirebaseStorage
import Foundation
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift

protocol DeleteAccountUseCaseProtocol {
    func execute() -> Completable
}

struct DeleteAccountUseCase: DeleteAccountUseCaseProtocol {
    
    // MARK: Dependencies
    
    let userProfileRepository: UserProfileRepositoryProtocol
    let cvRepository: CVRepositoryProtocol
    let getAppleIDRefreshTokenFromKeychainUseCase: GetAppleIDRefreshTokenFromKeychainUseCaseProtocol
    let revokeAppleIDTokenUseCase: RevokeAppleIDRefreshTokenUseCaseProtocol
    let getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCaseProtocol
    
    init(
        userProfileRepository: UserProfileRepositoryProtocol,
        cvRepository: CVRepositoryProtocol,
        getAppleIDRefreshTokenFromKeychainUseCase: GetAppleIDRefreshTokenFromKeychainUseCaseProtocol,
        revokeAppleIDTokenUseCase: RevokeAppleIDRefreshTokenUseCaseProtocol,
        getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCaseProtocol
    ) {
        self.userProfileRepository = userProfileRepository
        self.cvRepository = cvRepository
        self.getAppleIDRefreshTokenFromKeychainUseCase = getAppleIDRefreshTokenFromKeychainUseCase
        self.revokeAppleIDTokenUseCase = revokeAppleIDTokenUseCase
        self.getCurrentAuthProviderIDUseCase = getCurrentAuthProviderIDUseCase
    }
    
    func execute() -> Completable {
        ItsMEUserDefaults.allowsAutoLogin = false
        
        let deleteUserProfile = userProfileRepository.deleteUserProfile()
            .andThenJustNext()
        let deleteAllCVs = cvRepository.deleteAllCVs()
            .andThenJustNext()
        let deleteStorage = Single<Void>.just(())
            .map { try StoragePath().userProfileImage }
            .flatMap {
                return Storage.storage().reference().child($0).rx.delete()
                    .andThenJustNext()
            }
        let unlinkProvider = getCurrentAuthProviderIDUseCase.execute()
            .flatMap { providerID -> Single<Void> in
                switch providerID {
                case .kakao:
                    return UserApi.shared.rx.unlink()
                        .andThenJustNext()
                case .apple:
                    let refreshToken = try getAppleIDRefreshTokenFromKeychainUseCase.execute()
                    return revokeAppleIDTokenUseCase.execute(withRefreshToken: refreshToken)
                }
            }
        let deleteAccount = userProfileRepository.deleteAccount()
        
        return Single.zip(deleteUserProfile, deleteAllCVs, deleteStorage, unlinkProvider)
            .mapToVoid()
            .catchAndReturn(())
            .flatMap { deleteAccount }
            .asCompletable()
    }
}
