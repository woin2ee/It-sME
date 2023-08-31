//
//  AppDelegate.swift
//  It'sME
//
//  Created by MacBook Air on 2022/11/07.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import RxKakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let infoDictionaryKey: String = "KAKAO_NATIVE_APP_KEY"
        guard let appKey = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String else {
            fatalError("Info.plist 파일에 \(infoDictionaryKey) 키 항목이 없습니다.")
        }
        RxKakaoSDK.initSDK(appKey: appKey)
        manipulateAuthStatusForTest()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate {

    private func manipulateAuthStatusForTest() {
        let launchArguments = CommandLine.arguments

        guard launchArguments.contains("-TEST") else {
            return
        }

        guard let index = launchArguments.firstIndex(of: "-AUTHENTICATION"),
              let optionValue = launchArguments[ifExists: index + 1],
              optionValue == "TRUE"
        else {
            try? Auth.auth().signOut()
            return
        }

        Task {
            do {
                _ = try await Auth.auth().signIn(withEmail: "itsme_ui_test_1@test.com", password: "ItsME_UI_TEST_1_PASSWORD")
            } catch {
                fatalError("\(error)")
            }
        }
    }
}
