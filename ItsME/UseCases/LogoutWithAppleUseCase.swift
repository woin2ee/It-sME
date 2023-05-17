//
//  LogoutWithApple.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/05/10.
//

import FirebaseAuth
import ItsMEUtil

protocol LogoutWithAppleUseCaseProtocol {
    func execute()
}

struct LogoutWithAppleUseCase: LogoutWithAppleUseCaseProtocol {
    
    // MARK: Shared Instance
    
    static let shared: LogoutWithAppleUseCase = .init()
    
    // MARK: Execute
    
    func execute() {
        ItsMEUserDefaults.allowsAutoLogin = false
        ItsMEUserDefaults.removeAppleUserID()
        ItsMEUserDefaults.isLoggedInAsApple = false
        do {
            try Auth.auth().signOut()
        } catch {
            ItsMELogger.standard.error("\(error)")
        }
    }
}
