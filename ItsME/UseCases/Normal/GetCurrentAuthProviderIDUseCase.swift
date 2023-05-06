//
//  GetCurrentAuthProviderIDUseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/28.
//

import FirebaseAuth
import Foundation

struct GetCurrentAuthProviderIDUseCase: UseCase {
    
    func execute(input: Void = ()) -> AuthProviderID? {
        guard let providerID = Auth.auth().currentUser?.providerData.first?.providerID else {
            return nil
        }
        return .init(rawValue: providerID)
    }
}
