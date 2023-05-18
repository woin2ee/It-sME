//
//  DIContainer.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import Foundation

struct DIContainer {
    
    private init() {}
    
    static func makeHomeViewController() -> HomeViewController {
        let viewModel: HomeViewModel = .init(userRepository: .shared, cvRepository: .shared)
        let viewController: HomeViewController = .init(viewModel: viewModel)
        return viewController
    }
    
    static func makeLoginViewController() -> LoginViewController {
        let viewModel: LoginViewModel = .init(
            saveAppleIDRefreshTokenToKeychainUseCase: makeSaveAppleIDRefreshTokenToKeychainUseCase(),
            loginWithAppleUseCase: makeLoginWithAppleUseCase(),
            loginWithKakaoUseCase: makeLoginWithKakaoUseCase(),
            signInToFirebaseUseCase: makeSignInToFirebaseUseCase(),
            getNicknameAndEmailForKakaoUseCase: makeGetNicknameAndEmailForKakaoUseCase(),
            userRepository: makeUserProfileRepository()
        )
        let viewController: LoginViewController = .init(viewModel: viewModel)
        return viewController
    }
    
    static func makeProfileEditingViewController(initialProfileImageData: Data?, initialUserProfile: UserProfile) -> ProfileEditingViewController {
        let viewModel: ProfileEditingViewModel = .init(
            deleteAccountUseCase: makeDeleteAccountUseCase(),
            logoutUseCase: makeLogoutUseCase(),
            saveProfileImageUseCase: makeSaveProfileImageUseCase(),
            getProfileImageUseCase: makeGetProfileImageUseCase(),
            saveUserProfileUseCase: SaveUserProfileUseCase.shared,
            getUserProfileUseCase: GetUserProfileUseCase.shared,
            initialProfileImageData: initialProfileImageData,
            initialUserProfile: initialUserProfile
        )
        let viewController: ProfileEditingViewController = .init(viewModel: viewModel)
        return viewController
    }
    
    static func makeSignUpViewController(nameAndEmailForSignUp: (name: String, email: String)) -> SignUpViewController {
        let viewModel: SignUpViewModel = .init(
            userRepository: .shared,
            userNameForSignUp: nameAndEmailForSignUp.0,
            userEmailForSignUp: nameAndEmailForSignUp.1
        )
        let viewController: SignUpViewController = .init(viewModel: viewModel)
        return viewController
    }
    
    static func makeCVEditViewController(editingType: CVEditViewModel.EditingType) -> CVEditViewController {
        let viewModel: CVEditViewModel = .init(
            cvRepository: .shared,
            editingType: editingType
        )
        let viewController: CVEditViewController = .init(viewModel: viewModel)
        return viewController
    }
    
    static func makeTotalCVViewController(cvInfo: CVInfo) -> TotalCVViewController {
        let viewModel: TotalCVViewModel = .init(
            userRepository: .shared,
            cvRepository: .shared,
            cvInfo: cvInfo
        )
        let viewController: TotalCVViewController = .init(viewModel: viewModel)
        return viewController
    }
    
    static func makeResumeItemEditingViewController(
        editingType: ResumeItemEditingViewModel.EditingType,
        delegate: ResumeItemEditingViewModelDelegate
    ) -> ResumeItemEditingViewController {
        let viewModel: ResumeItemEditingViewModel = .init(
            editingType: editingType,
            delegate: delegate
        )
        let viewController: ResumeItemEditingViewController = .init(viewModel: viewModel)
        return viewController
    }
}

extension DIContainer {
    
    static func makeGetCurrentAuthProviderIDUseCase() -> GetCurrentAuthProviderIDUseCaseProtocol {
        return GetCurrentAuthProviderIDUseCase.shared
    }
    
    static func makeGetAppleIDRefreshTokenFromKeychainUseCase() -> GetAppleIDRefreshTokenFromKeychainUseCaseProtocol {
        return GetAppleIDRefreshTokenFromKeychainUseCase.shared
    }
    
    static func makeSaveAppleIDRefreshTokenToKeychainUseCase() -> SaveAppleIDRefreshTokenToKeychainUseCaseProtocol {
        return SaveAppleIDRefreshTokenToKeychainUseCase.shared
    }
    
    static func makeLoginWithAppleUseCase() -> LoginWithAppleUseCaseProtocol {
        return LoginWithAppleUseCase.shared
    }
    
    static func makeLoginWithKakaoUseCase() -> LoginWithKakaoUseCaseProtocol {
        return LoginWithKakaoUseCase.shared
    }
    
    static func makeSignInToFirebaseUseCase() -> SignInToFirebaseUseCaseProtocol {
        return SignInToFirebaseUseCase.shared
    }
    
    static func makeLogoutWithAppleUseCase() -> LogoutWithAppleUseCaseProtocol {
        return LogoutWithAppleUseCase.shared
    }
    
    static func makeLogoutUseCase() -> LogoutUseCaseProtocol {
        return LogoutUseCase.shared
    }
    
    static func makeRevokeAppleIDTokenUseCase() -> RevokeAppleIDRefreshTokenUseCaseProtocol {
        return RevokeAppleIDRefreshTokenUseCase.shared
    }
    
    static func makeDeleteAccountUseCase() -> DeleteAccountUseCaseProtocol {
        return DeleteAccountUseCase.shared
    }
    
    static func makeGetNicknameAndEmailForKakaoUseCase() -> GetNicknameAndEmailForKakaoUseCaseProtocol {
        return GetNicknameAndEmailForKakaoUseCase.shared
    }
    
    static func makeSaveProfileImageUseCase() -> SaveProfileImageUseCaseProtocol {
        return SaveProfileImageUseCase.shared
    }
    
    static func makeGetProfileImageUseCase() -> GetProfileImageUseCaseProtocol {
        return GetProfileImageUseCase.shared
    }
}

extension DIContainer {
    
    static func makeUserProfileRepository() -> UserProfileRepositoryProtocol {
        return UserProfileRepository.shared
    }
    
    static func makeCVRepository() -> CVRepositoryProtocol {
        return CVRepository.shared
    }
}

#if DEBUG

extension DIContainer {
    
    static var mock: DIContainerMock { return .init() }
    
    struct DIContainerMock {
        
        fileprivate init() {}
        
        func makeSignUpViewController() -> SignUpViewController {
            return DIContainer.makeSignUpViewController(nameAndEmailForSignUp: ("", ""))
        }
        
        func makeProfileEditingViewController() -> ProfileEditingViewController {
            return DIContainer.makeProfileEditingViewController(initialProfileImageData: nil, initialUserProfile: .empty)
        }
    }
}

#endif
