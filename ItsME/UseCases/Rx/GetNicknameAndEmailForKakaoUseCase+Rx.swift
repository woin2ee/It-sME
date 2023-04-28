//
//  GetNicknameAndEmailForKakaoUseCase+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift

extension GetNicknameAndEmailForKakaoUseCase: ReactiveCompatible {}

extension Reactive where Base == GetNicknameAndEmailForKakaoUseCase {
    
    func execute() -> Single<(name: String, email: String)> {
        return UserApi.shared.rx.me()
            .map { user in
                return (name: user.kakaoAccount?.profile?.nickname ?? "",
                        email: user.kakaoAccount?.email ?? "")
            }
    }
}
