//
//  StoragePath.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/04.
//

import FirebaseAuth
import Foundation

struct StoragePath {

    /// 프로필 이미지가 저장되는 End point 입니다.
    ///
    /// - Throws: 'FIRAuthErrorCodeNullUser' if currentUser is nil.
    var userProfileImage: String {
        get throws {
            guard let uid = Auth.auth().currentUser?.uid else {
                throw AuthErrorCode(.nullUser)
            }

            return "images/profile/\(uid)/profile.jpeg"
        }
    }
}
