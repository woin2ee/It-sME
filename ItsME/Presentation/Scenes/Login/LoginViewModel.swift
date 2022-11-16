//
//  LoginViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/15.
//

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    struct Input {
        let kakaoLoginRequest: Signal<Void>
        let appleLoginRequest: Signal<Void>
    }
    
    struct Output {
        let loggedIn: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let loggedInKakao = input.kakaoLoginRequest
            .asDriver(onErrorDriveWith: .empty())
        
        let loggedInApple = input.appleLoginRequest
            .asDriver(onErrorDriveWith: .empty())
        
        let loggedIn = Driver.merge(loggedInKakao, loggedInApple)
        
        return .init(loggedIn: loggedIn)
    }
}
