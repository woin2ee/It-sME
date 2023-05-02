//
//  LogoutUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import Foundation

struct LogoutUseCase {
    
    // MARK: Dependencies
    
    let getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCase
    
    init(getCurrentAuthProviderIDUseCase: GetCurrentAuthProviderIDUseCase) {
        self.getCurrentAuthProviderIDUseCase = getCurrentAuthProviderIDUseCase
    }
}
