//
//  ProfileEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/01.
//

import RxSwift
import RxCocoa
import Then

final class ProfileEditingViewModel: ViewModelType {
    
    struct Input {
        let tapEditingCompleteButton: Signal<Void>
        let userName: Driver<String>
        let viewDidLoad: Driver<Void>
        let logoutTrigger: Signal<Void>
    }
    
    struct Output {
        let userName: Driver<String>
        let userInfoItems: Driver<[UserInfoItem]>
        let educationItems: Driver<[EducationItem]>
        let tappedEditingCompleteButton: Signal<UserInfo>
        let viewDidLoad: Driver<Void>
        let logoutComplete: Signal<Void>
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
    var currentEmail: String {
        userInfoRelay.value.email.contents
    }
    var currentPhoneNumber: String {
        userInfoRelay.value.phoneNumber.contents
    }
    var currentAddress: String {
        userInfoRelay.value.address.contents
    }
    var currentOtherItems: [UserInfoItem] {
        userInfoRelay.value.otherItems
    }
    var currentAllItems: [UserInfoItem] {
        userInfoRelay.value.allItems
    }
    var currentEducationItems: [EducationItem] {
        userInfoRelay.value.educationItems
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
                    .doOnNext { self.userInfoRelay.accept($0) }
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
            }
        
        let userName = Driver.merge(input.userName,
                                    userInfoDriver.map { $0.name })
            .startWith(userInfoRelay.value.name)
            .doOnNext { self.userInfoRelay.value.name = $0 }
        let userInfoItems = userInfoDriver.map { $0.allItems }
        let educationItems = userInfoDriver.map { $0.educationItems }
        let tappedEditingCompleteButton = input.tapEditingCompleteButton
            .withLatestFrom(userInfoDriver)
            .doOnNext { print($0) } // TODO: 유저 정보 저장
        
        let logoutComplete = input.logoutTrigger
            .doOnNext { AppLoginStatusManager.shared.logout() }
        
        return .init(
            userName: userName,
            userInfoItems: userInfoItems,
            educationItems: educationItems,
            tappedEditingCompleteButton: tappedEditingCompleteButton,
            viewDidLoad: viewDidLoad,
            logoutComplete: logoutComplete
        )
    }
}

// MARK: - Internal Functions

extension ProfileEditingViewModel {
    
    func deleteEducationItem(at indexPath: IndexPath) {
        let userInfo = userInfoRelay.value
        userInfo.educationItems.remove(at: indexPath.row)
        userInfoRelay.accept(userInfo)
    }
    
    func updateBirthday(_ userInfoItem: UserInfoItem) {
        let userInfo = userInfoRelay.value
        userInfo.birthday = userInfoItem
        userInfoRelay.accept(userInfo)
    }
    
    func updateEmail(_ email: String) {
        let userInfo = userInfoRelay.value
        userInfo.email.contents = email
        userInfoRelay.accept(userInfo)
    }
    
    func updatePhoneNumber(_ phoneNumber: String) {
        let userInfo = userInfoRelay.value
        userInfo.phoneNumber.contents = phoneNumber
        userInfoRelay.accept(userInfo)
    }
    
    func updateAddress(_ address: String) {
        let userInfo = userInfoRelay.value
        userInfo.address.contents = address
        userInfoRelay.accept(userInfo)
    }
}

// MARK: - EducationEditingViewModelDelegate

extension ProfileEditingViewModel: EducationEditingViewModelDelegate {
    
    func educationEditingViewModelDidEndEditing(with educationItem: EducationItem, at indexPath: IndexPath?) {
        let userInfo = userInfoRelay.value
        if let indexPath = indexPath, userInfo.educationItems.indices ~= indexPath.row {
            userInfo.educationItems[indexPath.row] = educationItem
            userInfoRelay.accept(userInfo)
        }
    }
    
    func educationEditingViewModelDidAppend(educationItem: EducationItem) {
        let userInfo = userInfoRelay.value
        userInfo.educationItems.append(educationItem)
        userInfoRelay.accept(userInfo)
    }
}

// MARK: - OtherItemEditingViewModelDelegate

extension ProfileEditingViewModel: OtherItemEditingViewModelDelegate {
    
    func otherItemEditingViewModelDidEndEditing(with otherItem: UserInfoItem, at index: IndexPath.Index?) {
        let userInfo = userInfoRelay.value
        if let index = index, userInfo.otherItems.indices ~= index {
            userInfo.otherItems[index] = otherItem
            userInfoRelay.accept(userInfo)
        }
    }
    
    func otherItemEditingViewModelDidAppend(otherItem: UserInfoItem) {
        let userInfo = userInfoRelay.value
        userInfo.otherItems.append(otherItem)
        userInfoRelay.accept(userInfo)
    }
}
