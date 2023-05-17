//
//  FIRAuth+isLoggedIn.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/03.
//

import FirebaseAuth
import Foundation

extension Auth {
    
    public var isLoggedIn: Bool {
        (self.currentUser != nil) ? true : false
    }
}
