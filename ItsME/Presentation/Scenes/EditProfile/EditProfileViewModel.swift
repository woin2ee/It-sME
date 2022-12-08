//
//  EditProfileViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/01.
//

import RxSwift
import RxCocoa

final class EditProfileViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Signal<Void>
        let tapEditingCompleteButton: Signal<Void>
    }
    
    struct Output {
        let userInfo: Driver<UserInfo>
    }
    
    private let userRepository: UserRepository = .init()
    
    func transform(input: Input) -> Output {
        let userInfo = input.viewDidLoad
            .flatMapLatest { _ in
                self.userRepository.getUserInfo(byUID: "testUser") // FIXME: 유저 고유 ID 저장 방안 필요
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        return .init(userInfo: userInfo)
    }
}
