//
//  DeleteAccountUseCase+Rx.swift
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

extension DeleteAccountUseCase: ReactiveCompatible {}

extension Reactive where Base == DeleteAccountUseCase {
    
    func execute() -> Completable {
        ItsMEUserDefaults.allowsAutoLogin = false
        
        let deleteUserProfile = self.base.userProfileRepository.deleteUserProfile()
            .andThenJustOnNext()
        let deleteAllCVs = self.base.cvRepository.deleteAllCVs()
            .andThenJustOnNext()
        let deleteStorage = Single<Void>.just(())
            .map { try StoragePath().userProfileImage }
            .flatMap {
                return Storage.storage().reference().child($0).rx.delete()
                    .andThenJustOnNext()
            }
        let unlinkProvider = Auth.auth().rx.currentUser
            .map(\.providerData.first)
            .unwrapOrThrow()
            .map { AuthProviderID(rawValue: $0.providerID) }
            .unwrapOrThrow()
            .flatMap { providerID -> Single<Void> in
                switch providerID {
                case .kakao:
                    return UserApi.shared.rx.unlink()
                        .andThenJustOnNext()
                case .apple:
                    let refreshToken = try self.base.getAppleIDRefreshTokenFromKeychainUseCase.execute()
                    return self.base.revokeAppleIDTokenUseCase.rx.execute(refreshToken: refreshToken)
                }
            }
        let deleteAccount = self.base.userProfileRepository.deleteAccount()
        
        return Single.zip(deleteUserProfile, deleteAllCVs, deleteStorage, unlinkProvider)
            .mapToVoid()
            .catchAndReturn(())
            .flatMap { deleteAccount }
            .asCompletable()
    }
}
