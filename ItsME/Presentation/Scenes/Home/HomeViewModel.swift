//
//  HomeViewModel.swift
//  It'sME
//
//  Created by Jaewon Yun on 2022/11/09.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Signal<Void>
    }
    
    struct Output {
        let userInfo: Driver<UserInfo>
    }
    
    private let userRepository: UserRepository = .init()
    
    func transform(input: Input) -> Output {
        let userInfo = input.viewWillAppear
            .flatMapLatest { _ in
                return self.userRepository.getUserInfo(byUID: "testUser")
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        return Output(userInfo: userInfo)
    }
}
