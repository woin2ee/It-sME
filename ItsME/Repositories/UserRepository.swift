//
//  UserRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/13.
//

import RxSwift

final class UserRepository {
    
    // FIXME: 미구현상태
    func getUserInfo() -> Observable<UserInfo> {
        return .of(
            UserInfo(
                name: "Bob",
                profileImageURL: "",
                birthday: Date(),
                address: "abcd",
                phoneNumber: "010-1234-1234",
                email: "test@gmail.com",
                otherItems: []
            )
        )
    }
}
