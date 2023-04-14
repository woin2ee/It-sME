//
//  ItsMEUserDefaults.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/07.
//

import Foundation

struct ItsMEUserDefaults {
    
    @UserDefault(key: "appleUserID", defaultValue: nil)
    private(set) static var appleUserID: String?
    
    @UserDefault(key: "isLoggedInAsApple", defaultValue: false)
    static var isLoggedInAsApple: Bool
    
    /// 데이터베이스에 유저 정보가 존재하거나 로그인된 상태일 경우 `true` 로 설정됩니다. 회원가입이 필요하거나 로그아웃된 상태일 경우 `false` 입니다.
    @UserDefault(key: "allowsAutoLogin", defaultValue: false)
    static var allowsAutoLogin: Bool
}

extension ItsMEUserDefaults {
    
    static func setAppleUserID(_ userID: String) {
        appleUserID = userID
    }
    
    static func removeAppleUserID() {
        UserDefaults.standard.removeObject(forKey: "appleUserID")
    }
}

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
