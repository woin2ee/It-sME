//
//  Path.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/04.
//

import FirebaseAuth
import Foundation

struct Path {

    enum PathError: Error {
        case invalidCurrentUser
    }

    var userProfileImage: String {
        get throws {
            guard let uid = Auth.auth().currentUser?.uid else {
                throw PathError.invalidCurrentUser
            }
            return "images/profile/\(uid)/profile.jpeg"
        }
    }
}
