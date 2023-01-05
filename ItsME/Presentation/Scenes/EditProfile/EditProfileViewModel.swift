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
        let tapEditingCompleteButton: Signal<UserInfo>
    }
    
    struct Output {
        let userName: Driver<String>
        let userInfoItems: Driver<[UserInfoItem]>
        let educationItems: Driver<[EducationItem]>
        let tappedEditingCompleteButton: Signal<UserInfo>
    }
    
    private let userRepository: UserRepository = .init()
    
    private let educationItemsSubject: BehaviorSubject<[EducationItem]> = .init(value: [])
    
    func transform(input: Input) -> Output {
        let userInfo = input.viewDidLoad
            .flatMapLatest { _ -> Driver<UserInfo> in
                self.userRepository.getUserInfo(byUID: "testUser") // FIXME: 유저 고유 ID 저장 방안 필요
                    .asDriver(onErrorDriveWith: .empty())
            }
            .do(onNext: initializeEducationItemsSubject)
        let userName = userInfo.map { $0.name }
        let userInfoItems = userInfo.map { $0.defaultItems + $0.otherItems }
        let educationItems = educationItemsSubject.asDriver(onErrorDriveWith: .empty())
        
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

// MARK: - Private Functions

private extension EditProfileViewModel {
    
    func initializeEducationItemsSubject(_ userInfo: UserInfo) {
        educationItemsSubject.onNext(userInfo.educationItems)
    }
}
