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
        let tapEditingCompleteButton: Signal<Void>
        let userName: Driver<String>
    }
    
    struct Output {
        let userName: Driver<String>
        let userInfoItems: Driver<[UserInfoItem]>
        let educationItems: Driver<[EducationItem]>
        let tappedEditingCompleteButton: Signal<UserInfo>
    }
    
    private let userRepository: UserRepository = .init()
    
    private let userInfoRelay: BehaviorRelay<UserInfo>
    
    init(userInfo: UserInfo) {
        self.userInfoRelay = .init(value: userInfo)
    }
    
    func transform(input: Input) -> Output {
        let userInfoDriver = userInfoRelay.asDriver()
        
        let userName = Driver.merge(input.userName.skip(1),
                                    userInfoDriver.map { $0.name })
            .do(onNext: { userName in
                self.userInfoRelay.value.name = userName
            })
        let userInfoItems = userInfoDriver.map { $0.defaultItems + $0.otherItems }
        let educationItems = userInfoDriver.map { $0.educationItems }
        let tappedEditingCompleteButton = input.tapEditingCompleteButton
            .withLatestFrom(userInfoDriver)
            .do(onNext: { userInfo in
                // TODO: 유저 정보 저장
                print(userInfo)
            })
        
        return .init(
            userName: userName,
            userInfoItems: userInfoItems,
            educationItems: educationItems,
            tappedEditingCompleteButton: tappedEditingCompleteButton
        )
    }
}

// MARK: - Internal Functions

extension EditProfileViewModel {
    
    func deleteEducationItem(at indexPath: IndexPath) {
        let userInfo = userInfoRelay.value
        userInfo.educationItems.remove(at: indexPath.row)
        userInfoRelay.accept(userInfo)
    }
    
    func addUserInfoItem(_ userInfoItem: UserInfoItem) {
        let userInfo = userInfoRelay.value
        userInfo.otherItems.append(userInfoItem)
        userInfoRelay.accept(userInfo)
    }
}
