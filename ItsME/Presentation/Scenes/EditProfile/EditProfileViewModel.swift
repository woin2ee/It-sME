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
        let tapEditingCompleteButton: Signal<UserInfo>
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
        
        let userName = userInfoDriver.map { $0.name }
        let userInfoItems = userInfoDriver.map { $0.defaultItems + $0.otherItems }
        let educationItems = userInfoDriver.map { $0.educationItems }
        let tappedEditingCompleteButton = input.tapEditingCompleteButton
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
        var educationItems = userInfo.educationItems
        educationItems.remove(at: indexPath.row)
        
        let newUserInfo: UserInfo = .init(
            name: userInfo.name,
            profileImageURL: userInfo.profileImageURL,
            birthday: userInfo.birthday,
            address: userInfo.address,
            phoneNumber: userInfo.phoneNumber,
            email: userInfo.email,
            otherItems: userInfo.otherItems,
            educationItems: educationItems
        )
        userInfoRelay.accept(newUserInfo)
    }
}
