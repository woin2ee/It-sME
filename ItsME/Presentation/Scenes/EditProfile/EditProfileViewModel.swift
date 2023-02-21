//
//  EditProfileViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/01.
//

import RxSwift
import RxCocoa
import Then

final class EditProfileViewModel: ViewModelType {
    
    struct Input {
        let tapEditingCompleteButton: Signal<Void>
        let userName: Driver<String>
        let viewDidLoad: Driver<Void>
    }
    
    struct Output {
        let userName: Driver<String>
        let userInfoItems: Driver<[UserInfoItem]>
        let educationItems: Driver<[EducationItem]>
        let tappedEditingCompleteButton: Signal<UserInfo>
        let viewDidLoad: Driver<Void>
    }
    
    private let userRepository: UserRepository = .init()
    
    private let userInfoRelay: BehaviorRelay<UserInfo>
    
    var currentBirthday: Date {
        let birthday = userInfoRelay.value.birthday.contents
        let dateFormatter = DateFormatter.init().then {
            $0.dateFormat = "yyyy.MM.dd."
        }
        return dateFormatter.date(from: birthday) ?? .now
    }
    
    var currentOtherItems: [UserInfoItem] {
        userInfoRelay.value.otherItems
    }
    
    var currentAllItems: [UserInfoItem] {
        userInfoRelay.value.allItems
    }
    
    init(userInfo: UserInfo) {
        self.userInfoRelay = .init(value: userInfo)
    }
    
    func transform(input: Input) -> Output {
        let userInfoDriver = userInfoRelay.asDriver()
        
        let viewDidLoad = input.viewDidLoad
            .filter { self.userInfoRelay.value == .empty }
            .flatMapLatest { _ -> Driver<Void> in
                self.userRepository.getUserInfo(byUID: "testUser")
                    .do(onNext: { userInfo in
                        self.userInfoRelay.accept(userInfo)
                    })
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
            }
        
        let userName = Driver.merge(input.userName.skip(1),
                                    userInfoDriver.map { $0.name })
            .do(onNext: { userName in
                self.userInfoRelay.value.name = userName
            })
        let userInfoItems = userInfoDriver.map { $0.allItems }
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
            tappedEditingCompleteButton: tappedEditingCompleteButton,
            viewDidLoad: viewDidLoad
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
    
    func appendUserInfoItem(_ userInfoItem: UserInfoItem) {
        let userInfo = userInfoRelay.value
        userInfo.otherItems.append(userInfoItem)
        userInfoRelay.accept(userInfo)
    }
    
    func updateBirthday(_ userInfoItem: UserInfoItem) {
        let userInfo = userInfoRelay.value
        userInfo.birthday = userInfoItem
        userInfoRelay.accept(userInfo)
    }
    
    func updateOtherUserInfoItem(_ userInfoItem: UserInfoItem, at index: IndexPath.Index) {
        let userInfo = userInfoRelay.value
        if userInfo.otherItems.indices ~= index {
            userInfo.otherItems[index] = userInfoItem
            userInfoRelay.accept(userInfo)
        }
    }
}
