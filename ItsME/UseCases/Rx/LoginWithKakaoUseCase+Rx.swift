//
//  LoginWithKakaoUseCase+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift

extension LoginWithKakaoUseCase: ReactiveCompatible {}

extension Reactive where Base == LoginWithKakaoUseCase {
    
    func execute(withRawNonce rawNonce: String) -> Observable<OAuthToken> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk(nonce: sha256(rawNonce))
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount(nonce: sha256(rawNonce))
        }
    }
}
