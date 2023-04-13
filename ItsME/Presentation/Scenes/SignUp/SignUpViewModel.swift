//
//  SignUpViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/11.
//

import Foundation

final class SignUpViewModel: ViewModelType {
    
    func transform(input: Input) -> Output {
        // TODO: 추가 필요 `ItsMEUserDefaults.allowsAutoLogin = true`
        
        return .init()
    }
}

// MARK: - Input & Output

extension SignUpViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
}
