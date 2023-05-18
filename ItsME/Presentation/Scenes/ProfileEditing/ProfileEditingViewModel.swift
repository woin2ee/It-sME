//
//  ProfileEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/01.
//

import FirebaseStorage
import RxSwift
import RxCocoa
import Then

final class ProfileEditingViewModel: ViewModelType {
    
    private let deleteAccountUseCase: DeleteAccountUseCaseProtocol
    private let logoutUseCase: LogoutUseCaseProtocol
    private let saveProfileImageUseCase: SaveProfileImageUseCaseProtocol
    private let getProfileImageUseCase: GetProfileImageUseCaseProtocol
    private let saveUserProfileUseCase: SaveUserProfileUseCaseProtocol
    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol
    
    private let initialProfileImageData: Data?
    private let userInfoRelay: BehaviorRelay<UserProfile>
    
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
    var currentOtherItems: [UserBasicProfileInfo] {
        userInfoRelay.value.otherItems
    }
    var currentAllItems: [UserBasicProfileInfo] {
        userInfoRelay.value.allItems
    }
    var currentEducationItems: [Education] {
        userInfoRelay.value.educationItems
    }
    
    init(
        deleteAccountUseCase: DeleteAccountUseCaseProtocol,
        logoutUseCase: LogoutUseCaseProtocol,
        saveProfileImageUseCase: SaveProfileImageUseCaseProtocol,
        getProfileImageUseCase: GetProfileImageUseCaseProtocol,
        saveUserProfileUseCase: SaveUserProfileUseCaseProtocol,
        getUserProfileUseCase: GetUserProfileUseCaseProtocol,
        initialProfileImageData: Data?,
        initialUserProfile: UserProfile
    ) {
        self.deleteAccountUseCase = deleteAccountUseCase
        self.logoutUseCase = logoutUseCase
        self.saveProfileImageUseCase = saveProfileImageUseCase
        self.getProfileImageUseCase = getProfileImageUseCase
        self.saveUserProfileUseCase = saveUserProfileUseCase
        self.getUserProfileUseCase = getUserProfileUseCase
        self.initialProfileImageData = initialProfileImageData
        self.userInfoRelay = .init(value: initialUserProfile)
    }
    
    func transform(input: Input) -> Output {
        let userInfoDriver = userInfoRelay.asDriver()
        
        let viewDidLoad = input.viewDidLoad
            .filter { self.userInfoRelay.value == .empty }
            .flatMapLatest { _ -> Driver<Void> in
                return self.getUserProfileUseCase.execute()
                    .doOnSuccess { self.userInfoRelay.accept($0) }
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
            }
        
        let profileImageData = Driver.merge(
            input.newProfileImageData,
            userInfoDriver.flatMap {
                return self.getProfileImageUseCase.execute(withStoragePath: $0.profileImageURL).map { $0 }
                    .asDriverOnErrorJustComplete()
            }
                .asObservable()
                .take(1)
                .asDriverOnErrorJustComplete()
        )
            .startWith(initialProfileImageData)
        
        let userName = Driver.merge(input.userName,
                                    userInfoDriver.map { $0.name })
            .startWith(userInfoRelay.value.name)
            .doOnNext { self.userInfoRelay.value.name = $0 }
        let userInfoItems = userInfoDriver.map { $0.allItems }
        let educationItems = userInfoDriver.map { $0.educationItems }
        let tappedEditingCompleteButton = input.tapEditingCompleteButton // TODO: Error 처리 고려
            .asObservable()
            .withLatestFrom(profileImageData)
            .compactMap { $0 }
            .flatMapFirst { self.saveProfileImageUseCase.execute(withImageData: $0) }
            .compactMap { $0.path }
            .flatMap { path in
                let userProfile = self.userInfoRelay.value
                userProfile.profileImageURL = path
                return self.saveUserProfileUseCase.execute(with: userProfile)
            }
            .asSignalOnErrorJustComplete()
        
        let logoutComplete = input.logoutTrigger
            .flatMapFirst { _ in
                return self.logoutUseCase.execute()
                    .andThenJustNext()
                    .asSignalOnErrorJustNext()
            }
        let deleteAccountComplete = input.deleteAccountTrigger
            .flatMapFirst { _ in
                return self.deleteAccountUseCase.execute()
                    .andThenJustNext()
                    .asSignalOnErrorJustNext()
            }
        
        return .init(
            profileImageData: profileImageData,
            userName: userName,
            userInfoItems: userInfoItems,
            educationItems: educationItems,
            tappedEditingCompleteButton: tappedEditingCompleteButton,
            viewDidLoad: viewDidLoad,
            logoutComplete: logoutComplete,
            deleteAccountComplete: deleteAccountComplete
        )
    }
}

// MARK: - Input & Output

extension ProfileEditingViewModel {
    
    struct Input {
        let tapEditingCompleteButton: Signal<Void>
        let userName: Driver<String>
        let viewDidLoad: Driver<Void>
        let logoutTrigger: Signal<Void>
        let deleteAccountTrigger: Signal<Void>
        let newProfileImageData: Driver<Data?>
    }
    
    struct Output {
        let profileImageData: Driver<Data?>
        let userName: Driver<String>
        let userInfoItems: Driver<[UserBasicProfileInfo]>
        let educationItems: Driver<[Education]>
        let tappedEditingCompleteButton: Signal<Void>
        let viewDidLoad: Driver<Void>
        let logoutComplete: Signal<Void>
        let deleteAccountComplete: Signal<Void>
    }
}

// MARK: - Internal Functions

extension ProfileEditingViewModel {
    
    func deleteEducationItem(at indexPath: IndexPath) {
        let userInfo = userInfoRelay.value
        userInfo.educationItems.remove(at: indexPath.row)
        userInfoRelay.accept(userInfo)
    }
    
    func updateBirthday(_ userInfoItem: UserBasicProfileInfo) {
        let userInfo = userInfoRelay.value
        userInfo.birthday = userInfoItem
        userInfoRelay.accept(userInfo)
    }
    
    func swapEducation(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        userInfoRelay.value.educationItems.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func endSwapEducation() {
        userInfoRelay.accept(userInfoRelay.value)
    }
}

// MARK: - EducationEditingViewModelDelegate

extension ProfileEditingViewModel: EducationEditingViewModelDelegate {
    
    func educationEditingViewModelDidEndEditing(with educationItem: Education, at index: IndexPath.Index) {
        let userInfo = userInfoRelay.value
        if userInfo.educationItems.indices ~= index {
            userInfo.educationItems[index] = educationItem
            userInfoRelay.accept(userInfo)
        }
    }
    
    func educationEditingViewModelDidAppend(educationItem: Education) {
        let userInfo = userInfoRelay.value
        userInfo.educationItems.append(educationItem)
        userInfoRelay.accept(userInfo)
    }
    
    func educationEditingViewModelDidDeleteEducationItem(at index: IndexPath.Index) {
        let userInfo = userInfoRelay.value
        userInfo.educationItems.remove(at: index)
        userInfoRelay.accept(userInfo)
    }
}

// MARK: - OtherItemEditingViewModelDelegate

extension ProfileEditingViewModel: OtherItemEditingViewModelDelegate {
    
    func otherItemEditingViewModelDidEndEditing(with otherItem: UserBasicProfileInfo, at index: IndexPath.Index) {
        let userInfo = userInfoRelay.value
        if userInfo.otherItems.indices ~= index {
            userInfo.otherItems[index] = otherItem
            userInfoRelay.accept(userInfo)
        }
    }
    
    func otherItemEditingViewModelDidAppend(otherItem: UserBasicProfileInfo) {
        let userInfo = userInfoRelay.value
        userInfo.otherItems.append(otherItem)
        userInfoRelay.accept(userInfo)
    }
    
    func otherItemEditingViewModelDidDeleteOtherItem(at index: IndexPath.Index) {
        let userInfo = userInfoRelay.value
        userInfo.otherItems.remove(at: index)
        userInfoRelay.accept(userInfo)
    }
}

// MARK: - AddressEditingViewModelDelegate

extension ProfileEditingViewModel: AddressEditingViewModelDelegate {
    
    func addressEditingViewModelDidEndEditing(with address: String) {
        let userInfo = userInfoRelay.value
        userInfo.address.contents = address
        userInfoRelay.accept(userInfo)
    }
}

// MARK: - PhoneNumberEditingViewModelDelegate

extension ProfileEditingViewModel: PhoneNumberEditingViewModelDelegate {
    
    func phoneNumberEditingViewModelDidEndEditing(with phoneNumber: String) {
        let userInfo = userInfoRelay.value
        userInfo.phoneNumber.contents = phoneNumber
        userInfoRelay.accept(userInfo)
    }
}

// MARK: - EmailEditingViewModelDelegate

extension ProfileEditingViewModel: EmailEditingViewModelDelegate {
    
    func emailEditingViewModelDidEndEditing(with email: String) {
        let userInfo = userInfoRelay.value
        userInfo.email.contents = email
        userInfoRelay.accept(userInfo)
    }
}
