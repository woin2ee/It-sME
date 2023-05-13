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
    
    static func makeProfileEditingViewController(initalProfileImageData: Data?, initialUserProfile: UserProfile) -> ProfileEditingViewController {
        let viewModel: ProfileEditingViewModel = .init(
            deleteAccountUseCase: makeDeleteAccountUseCase(),
            logoutUseCase: makeLogoutUseCase(),
            saveProfileImageUseCase: makeSaveProfileImageUseCase(),
            getProfileImageUseCase: makeGetProfileImageUseCase(),
            userRepository: makeUserProfileRepository(),
            cvRepository: makeCVRepository(),
            initalProfileImageData: initalProfileImageData,
            userProfile: initialUserProfile
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
}

extension DIContainer {
    
    static func makeGetCurrentAuthProviderIDUseCase() -> GetCurrentAuthProviderIDUseCaseProtocol {
        return GetCurrentAuthProviderIDUseCase()
    }
    
    static func makeGetAppleIDRefreshTokenFromKeychainUseCase() -> GetAppleIDRefreshTokenFromKeychainUseCaseProtocol {
        return GetAppleIDRefreshTokenFromKeychainUseCase.shared
    }
    
    static func makeSaveAppleIDRefreshTokenToKeychainUseCase() -> SaveAppleIDRefreshTokenToKeychainUseCaseProtocol {
        return SaveAppleIDRefreshTokenToKeychainUseCase()
    }
    
    static func makeLoginWithAppleUseCase() -> LoginWithAppleUseCaseProtocol {
        return LoginWithAppleUseCase()
    }
    
    static func makeLoginWithKakaoUseCase() -> LoginWithKakaoUseCaseProtocol {
        return LoginWithKakaoUseCase()
    }
    
    static func makeSignInToFirebaseUseCase() -> SignInToFirebaseUseCaseProtocol {
        return SignInToFirebaseUseCase()
    }
    
    static func makeLogoutWithAppleUseCase() -> LogoutWithAppleUseCaseProtocol {
        return LogoutWithAppleUseCase()
    }
    
    static func makeLogoutUseCase() -> LogoutUseCaseProtocol {
        return LogoutUseCase(
            getCurrentAuthProviderIDUseCase: makeGetCurrentAuthProviderIDUseCase(),
            logoutWithAppleUseCase: makeLogoutWithAppleUseCase()
        )
    }
    
    static func makeRevokeAppleIDTokenUseCase() -> RevokeAppleIDRefreshTokenUseCaseProtocol {
        return RevokeAppleIDRefreshTokenUseCase()
    }
    
    static func makeDeleteAccountUseCase() -> DeleteAccountUseCaseProtocol {
        return DeleteAccountUseCase(
            userProfileRepository: makeUserProfileRepository(),
            cvRepository: makeCVRepository(),
            getAppleIDRefreshTokenFromKeychainUseCase: makeGetAppleIDRefreshTokenFromKeychainUseCase(),
            revokeAppleIDTokenUseCase: makeRevokeAppleIDTokenUseCase(),
            getCurrentAuthProviderIDUseCase: makeGetCurrentAuthProviderIDUseCase()
        )
    }
    
    static func makeGetNicknameAndEmailForKakaoUseCase() -> GetNicknameAndEmailForKakaoUseCaseProtocol {
        return GetNicknameAndEmailForKakaoUseCase()
    }
    
    static func makeSaveProfileImageUseCase() -> SaveProfileImageUseCaseProtocol {
        return SaveProfileImageUseCase()
    }
    
    static func makeGetProfileImageUseCase() -> GetProfileImageUseCaseProtocol {
        return GetProfileImageUseCase()
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
            return DIContainer.makeProfileEditingViewController(initalProfileImageData: nil, initialUserProfile: .empty)
        }
    }
}

#endif
