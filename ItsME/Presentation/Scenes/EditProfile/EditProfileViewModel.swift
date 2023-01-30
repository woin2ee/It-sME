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
    
    private let educationItemsRelay: BehaviorRelay<[EducationItem]> = .init(value: [])
    
    func transform(input: Input) -> Output {
        let userInfo = input.viewDidLoad
            .flatMapLatest { _ -> Driver<UserInfo> in
                self.userRepository.getUserInfo(byUID: "testUser") // FIXME: 유저 고유 ID 저장 방안 필요
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: initializeEducationItemsRelay)
        let userName = userInfo.map { $0.name }
        let userInfoItems = userInfo.map { $0.defaultItems + $0.otherItems }
        let educationItems = educationItemsRelay.asDriver()
        
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
        var educationItems = educationItemsRelay.value
        educationItems.remove(at: indexPath.row)
        educationItemsRelay.accept(educationItems)
    }
}

// MARK: - Private Functions

private extension EditProfileViewModel {
    
    func initializeEducationItemsRelay(_ userInfo: UserInfo) {
        educationItemsRelay.accept(userInfo.educationItems)
    }
}
