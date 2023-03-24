//
//  AppLoginStatusManager.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/15.
//

import Foundation
import KakaoSDKUser

final class AppLoginStatusManager {
    
    /// 앱 사용자의 로그인 상태를 관리하는 싱글톤 객체입니다.
    static let shared: AppLoginStatusManager = .init()
    
    private init() {}
    
    private let uidRepository: UIDRepository = .shared
    
    /// 현재 로그인에 사용된 플랫폼입니다.
    private(set) var loginType: LoginType?
    
    /// 앱의 사용자가 현재 로그인 되어있는지 여부를 반환합니다.
    var isLoggedIn: Bool {
        if let uid = try? uidRepository.get(), uid.isNotEmpty {
            return true
        } else {
            return false
        }
    }
    
    /// 앱 사용자를 로그인 처리 합니다.
    func login(with loginType: LoginType, uid: UIDRepository.UID) throws {
        try uidRepository.save(uid)
        self.loginType = loginType
    }
    
    /// 앱 사용자를 로그아웃 처리 합니다.
    func logout() {
        defer { loginType = nil }
        if let loginType = loginType {
            switch loginType {
            case .apple:
                break
            case .kakao:
                UserApi.shared.logout(completion: { _ in })
            }
        }
        
        do {
            try uidRepository.remove()
        } catch {
            #if DEBUG
                debugPrint(error)
            #endif
            return
        }
    }
}

// MARK: - LoginType

extension AppLoginStatusManager {
    
    enum LoginType {
        case apple
        case kakao
    }
}
