//
//  LogoutUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import Foundation

struct LogoutUseCase {
    
    static let shared: LogoutUseCase = .init(getCurrentAuthProviderIDUseCase: .shared)
        
    // MARK: Dependencies
    
    let getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCase
    
    private init(getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCase) {
        self.getCurrentAuthProviderIDUseCase = getCurrentAuthProviderIDUseCase
    }
}
