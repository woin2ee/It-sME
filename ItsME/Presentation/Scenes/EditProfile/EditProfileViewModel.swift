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
        let userInfoItems: Driver<[UserInfoItem]>
        let educationItems: Driver<[EducationItem]>
    }
    
    private let userRepository: UserRepository = .init()
    
    func transform(input: Input) -> Output {
        let userInfo = input.viewDidLoad
            .flatMapLatest { _ in
                self.userRepository.getUserInfo(byUID: "testUser") // FIXME: 유저 고유 ID 저장 방안 필요
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let userInfoItems = userInfo.map { $0.defaultItems + $0.otherItems }
        
        let educationItems = userInfo.map { $0.educationItems }
        
        return .init(
            userInfoItems: userInfoItems,
            educationItems: educationItems
        )
    }
}
