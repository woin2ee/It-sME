//
//  ProfileEditingViewModelTests.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/08.
//

@testable import ItsME
import RxSwift
import RxTest
import XCTest

final class ProfileEditingViewModelTests: RxBaseTestCase {
    
    var sut: ProfileEditingViewModel!
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testLogoutCompleteWhenLogoutUseCaseError() {
        // Arrange
        sut = makeSUT(logoutUseCase: LogoutUseCaseMock(hasError: true))
        let trigger = testScheduler.createTrigger()
        let input = makeInput(logoutTrigger: trigger.asObservable())
        let output = sut.transform(input: input)
        
        // Act
        let result = testScheduler.start {
            return output.logoutComplete
        }
        
        // Assert
        XCTAssertRecordedElements(result.events, [()])
    }
}

extension ProfileEditingViewModelTests {
    
    private func makeSUT(
        deleteAccountUseCase: DeleteAccountUseCaseProtocol = DeleteAccountUseCaseMock(hasError: false),
        logoutUseCase: LogoutUseCaseProtocol = LogoutUseCaseMock(hasError: false),
        saveProfileImageUseCase: SaveProfileImageUseCaseProtocol = SaveProfileImageUseCaseMock(hasError: false),
        getProfileImageUseCase: GetProfileImageUseCaseProtocol = GetProfileImageUseCaseMock(hasError: false),
        saveUserProfileUseCase: SaveUserProfileUseCaseProtocol = SaveUserProfileUseCaseMock(hasError: false),
        getUserProfileUseCase: GetUserProfileUseCaseProtocol = GetUserProfileUseCaseMock(hasError: false),
        initialProfileImageData: Data? = nil,
        initialUserProfile: UserProfile = .empty
    ) -> ProfileEditingViewModel {
        return .init(
            deleteAccountUseCase: deleteAccountUseCase,
            logoutUseCase: logoutUseCase,
            saveProfileImageUseCase: saveProfileImageUseCase,
            getProfileImageUseCase: getProfileImageUseCase,
            saveUserProfileUseCase: saveUserProfileUseCase,
            getUserProfileUseCase: getUserProfileUseCase,
            initialProfileImageData: initialProfileImageData,
            initialUserProfile: initialUserProfile
        )
    }
    
    private func makeInput(
        tapEditingCompleteButton: Observable<Void> = .never(),
        userName: Observable<String> = .never(),
        viewDidLoad: Observable<Void> = .just(()),
        logoutTrigger: Observable<Void> = .never(),
        deleteAccountTrigger: Observable<Void> = .never(),
        newProfileImageData: Observable<Data?> = .never()
    ) -> ProfileEditingViewModel.Input {
        return .init(
            tapEditingCompleteButton: tapEditingCompleteButton.asSignalOnErrorJustComplete(),
            userName: userName.asDriverOnErrorJustComplete(),
            viewDidLoad: viewDidLoad.asDriverOnErrorJustComplete(),
            logoutTrigger: logoutTrigger.asSignalOnErrorJustComplete(),
            deleteAccountTrigger: deleteAccountTrigger.asSignalOnErrorJustComplete(),
            newProfileImageData: newProfileImageData.asDriverOnErrorJustComplete()
        )
    }
}
