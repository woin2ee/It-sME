//
//  SceneDelegate.swift
//  It'sME
//
//  Created by MacBook Air on 2022/11/07.
//

import AuthenticationServices
import FirebaseAuth
import ItsMEUtil
import UIKit
import KakaoSDKAuth
import RxKakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let rootNavigationController: UINavigationController = .init()
    
    let logoutWithAppleUseCase: LogoutWithAppleUseCaseProtocol = DIContainer.makeLogoutWithAppleUseCase()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = rootNavigationController
        
        setRootViewController()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if ItsMEUserDefaults.isLoggedInAsApple {
            guard let userID = ItsMEUserDefaults.appleUserID else {
                handleAppleIDLogout()
                return
            }
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userID) { credentialState, error in
                if let error = error {
                    ItsMELogger.standard.error("\(error)")
                    self.handleAppleIDLogout()
                    return
                }
                switch credentialState {
                case .authorized:
                    return
                default:
                    self.handleAppleIDLogout()
                    return
                }
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    
    private func handleAppleIDLogout() {
        DispatchQueue.main.async {
            let loginViewController = DIContainer.makeLoginViewController()
            self.rootNavigationController.setViewControllers([loginViewController], animated: false)
            self.logoutWithAppleUseCase.execute()
        }
    }
    
    private func setRootViewController() {
        let launchArguments = CommandLine.arguments
        let rootViewController: UIViewController
        
        if launchArguments.contains("-TEST"),
           let index = launchArguments.firstIndex(of: "-TARGET_VIEW_CONTROLLER") {
            switch launchArguments[index + 1] {
            case "HOME_VIEW_CONTROLLER":
                rootViewController = DIContainer.makeHomeViewController()
            case "PROFILE_EDITING_VIEW_CONTROLLER":
                rootViewController = DIContainer.makeProfileEditingViewController(initialProfileImageData: nil, initialUserProfile: .empty)
            default:
                fatalError("올바른 argument 를 입력해주세요.")
            }
        } else {
            rootViewController = (Auth.auth().isLoggedIn && ItsMEUserDefaults.allowsAutoLogin) ? {
                return DIContainer.makeHomeViewController()
            }() : {
                return DIContainer.makeLoginViewController()
            }()
        }
        
        rootNavigationController.setViewControllers([rootViewController], animated: false)
    }
}
