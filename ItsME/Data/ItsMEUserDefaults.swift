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
    
    static func setAppleUserID(_ userID: String) {
        appleUserID = userID
    }
    
    static func removeAppleUserID() {
        UserDefaults.standard.removeObject(forKey: "appleUserID")
    }
    
    @UserDefault(key: "isLoggedInAsApple", defaultValue: false)
    static var isLoggedInAsApple: Bool
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
