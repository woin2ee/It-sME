//
//  GetNicknameAndEmailForKakaoUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift

protocol GetNicknameAndEmailForKakaoUseCaseProtocol {
    func execute() -> Single<(name: String, email: String)>
}

struct GetNicknameAndEmailForKakaoUseCase {
    
    func execute() -> Single<(name: String, email: String)> {
        return UserApi.shared.rx.me()
            .map { user in
                return (name: user.kakaoAccount?.profile?.nickname ?? "",
                        email: user.kakaoAccount?.email ?? "")
            }
    }
}
