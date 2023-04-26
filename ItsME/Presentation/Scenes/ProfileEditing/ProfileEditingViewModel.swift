//
//  ProfileEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/01.
//

import FirebaseAuth
import FirebaseStorage
import KakaoSDKUser
import RxSwift
import RxCocoa
import Then

final class ProfileEditingViewModel: ViewModelType {
    
    private let getAppleIDRefreshTokenFromKeychainUseCase: GetAppleIDRefreshTokenFromKeychainUseCase = .init()
    private let revokeAppleIDTokenUseCase: RevokeAppleIDRefreshTokenUseCase = .init()
    
    private let userRepository: UserRepository = .shared
    private let cvRepository: CVRepository = .shared
    
    private let initalProfileImageData: Data?
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
    
    init(initalProfileImageData: Data?, userInfo: UserInfo) {
        self.initalProfileImageData = initalProfileImageData
        self.userInfoRelay = .init(value: userInfo)
    }
    
    func transform(input: Input) -> Output {
        let userInfoDriver = userInfoRelay.asDriver()
        
        let viewDidLoad = input.viewDidLoad
            .filter { self.userInfoRelay.value == .empty }
            .flatMapLatest { _ -> Driver<Void> in
                return self.userRepository.getUserInfo()
                    .doOnSuccess { self.userInfoRelay.accept($0) }
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
            }
        
        let profileImageData = Driver.merge(
            input.newProfileImageData,
            userInfoDriver.flatMap {
                Storage.storage().reference().child($0.profileImageURL).rx.getData().map { $0 }
                    .asDriverOnErrorJustComplete()
            }
                .asObservable()
                .take(1)
                .asDriverOnErrorJustComplete()
        )
            .startWith(initalProfileImageData)
        
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
            .flatMap { data in
                let path = try StoragePath().userProfileImage
                return Storage.storage().reference().child(path).rx.putData(data)
            }
            .compactMap { $0.path }
            .flatMap { path in
                let userInfo = self.userInfoRelay.value
                userInfo.profileImageURL = path
                return self.userRepository.saveUserInfo(userInfo)
            }
            .asSignalOnErrorJustComplete()
        
        let logoutComplete = makeLogoutComplete(with: input.logoutTrigger)
        let deleteAccountComplete = makeDeleteAccountComplete(with: input.deleteAccountTrigger)
        
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
        let userInfoItems: Driver<[UserInfoItem]>
        let educationItems: Driver<[EducationItem]>
        let tappedEditingCompleteButton: Signal<Void>
        let viewDidLoad: Driver<Void>
        let logoutComplete: Signal<Void>
        let deleteAccountComplete: Signal<Void>
    }
}

// MARK: - Private

private extension ProfileEditingViewModel {
    
    func makeLogoutComplete(with input: Signal<Void>) -> Signal<Void> {
        let logoutWithKakao = UserApi.shared.rx.logout()
            .andThenJustOnNext()
            .asSignal(onErrorJustReturn: ()) // TODO: 에러 발생 시 로그 심기
        let signOutFromFIRAuth = Auth.auth().rx.signOut()
            .andThenJustOnNext()
            .asSignal(onErrorJustReturn: ()) // TODO: 에러 발생 시 로그 심기
        
        return input
            .doOnNext {
                ItsMEUserDefaults.removeAppleUserID()
                ItsMEUserDefaults.isLoggedInAsApple = false
                ItsMEUserDefaults.allowsAutoLogin = false
            }
            .flatMapFirst {
                return Signal.zip(logoutWithKakao, signOutFromFIRAuth)
                    .mapToVoid()
            }
    }
    
    func makeDeleteAccountComplete(with input: Signal<Void>) -> Signal<Void> {
        let deleteUserInfo = userRepository.deleteUserInfo()
            .andThenJustOnNext()
            .asSignal(onErrorJustReturn: ()) // TODO: 에러 트래커 추가
        let deleteAllCVs = cvRepository.deleteAllCVs()
            .andThenJustOnNext()
            .asSignal(onErrorJustReturn: ()) // TODO: 에러 트래커 추가
        let deleteUserAuth = userRepository.deleteUser()
            .asSignal(onErrorJustReturn: ()) // TODO: 에러 트래커 추가
        let revokeProvider = makeRevokeProviderWithCurrentProviderID()
        
        return input
            .flatMapFirst {
                return Signal.zip(deleteUserInfo, deleteAllCVs, deleteUserAuth, revokeProvider)
                    .mapToVoid()
            }
    }
    
    func makeRevokeProviderWithCurrentProviderID() -> Signal<Void> {
        let source = Auth.auth().rx.currentUser
            .map(\.providerData.first)
            .unwrapOrThrow()
            .map { AuthProviderID(rawValue: $0.providerID) }
            .unwrapOrThrow()
            .flatMap { providerID -> Single<Void> in
                switch providerID {
                case .kakao:
                    return UserApi.shared.rx.unlink()
                        .andThenJustOnNext()
                case .apple:
                    let refreshToken = try self.getAppleIDRefreshTokenFromKeychainUseCase.execute()
                    return self.revokeAppleIDTokenUseCase.execute(refreshToken: refreshToken)
                }
            }
            .asSignal(onErrorJustReturn: ()) // 과정 중 에러가 발생해도 사용자에게는 계정 삭제 처리가 완료된걸로 보여야 경험을 해치지 않음
        return source
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
    
    func educationEditingViewModelDidEndEditing(with educationItem: EducationItem, at index: IndexPath.Index) {
        let userInfo = userInfoRelay.value
        if userInfo.educationItems.indices ~= index {
            userInfo.educationItems[index] = educationItem
            userInfoRelay.accept(userInfo)
        }
    }
    
    func educationEditingViewModelDidAppend(educationItem: EducationItem) {
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
    
    func otherItemEditingViewModelDidEndEditing(with otherItem: UserInfoItem, at index: IndexPath.Index) {
        let userInfo = userInfoRelay.value
        if userInfo.otherItems.indices ~= index {
            userInfo.otherItems[index] = otherItem
            userInfoRelay.accept(userInfo)
        }
    }
    
    func otherItemEditingViewModelDidAppend(otherItem: UserInfoItem) {
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
