//
//  AppLoginStatusManager.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/15.
//

import Foundation

final class AppLoginStatusManager {
    
    /// 앱 사용자의 로그인 상태를 관리하는 싱글톤 객체입니다.
    static let shared: AppLoginStatusManager = .init()
    
    private init() {}
    
    private let uidRepository: UIDRepository = .shared
    
    /// 앱의 사용자가 현재 로그인 되어있는지 여부를 반환합니다.
    var isLoggedIn: Bool {
        var result: Bool = false
        let semaphore: DispatchSemaphore = .init(value: 0)
        uidRepository.getUID { status, uid in
            if status == errSecSuccess, let uid = uid {
                result = true
                #if DEBUG
                    debugPrint("현재 로그인 되어있습니다. UID - \(uid)")
                #endif
            }
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
    
    /// 앱 사용자를 로그인 처리 합니다.
    func login(with uid: UIDRepository.UID) throws {
        var isSuccessLogin: Bool = false
        let semaphore: DispatchSemaphore = .init(value: 0)
        uidRepository.saveUID(uid) { status in
            if status == errSecSuccess {
                isSuccessLogin = true
            }
            semaphore.signal()
        }
        semaphore.wait()
        if !isSuccessLogin {
            throw AppLoginError.loginFail
        }
    }
    
    /// 앱 사용자를 로그아웃 처리 합니다.
    func logout() {
        uidRepository.removeUID()
    }
}

// MARK: - AppLoginError

extension AppLoginStatusManager {
    
    enum AppLoginError: Error {
        case loginFail
    }
}
