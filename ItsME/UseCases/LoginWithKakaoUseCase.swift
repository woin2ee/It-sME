//
//  LoginWithKakaoUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import Foundation
import ItsMEUtil
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift

protocol LoginWithKakaoUseCaseProtocol {
    func execute(withRawNonce rawNonce: String) -> Observable<OAuthToken>
}

struct LoginWithKakaoUseCase: LoginWithKakaoUseCaseProtocol {
    
    // MARK: Shared Instance
    
    static let shared: LoginWithKakaoUseCase = .init()
    
    // MARK: Execute
    
    func execute(withRawNonce rawNonce: String) -> Observable<OAuthToken> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk(nonce: sha256(rawNonce))
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount(nonce: sha256(rawNonce))
        }
    }
}
