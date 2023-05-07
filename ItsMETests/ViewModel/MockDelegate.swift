//
//  MockDelegate.swift
//  ItsMENoneHostAppTests
//
//  Created by Jaewon Yun on 2023/05/07.
//

@testable import ItsME
import Foundation

final class MockDelegate {
    
    var didCalledDelegateMethod: Bool = false
}

extension MockDelegate: PhoneNumberEditingViewModelDelegate {
    
    func phoneNumberEditingViewModelDidEndEditing(with phoneNumber: String) {
        didCalledDelegateMethod = true
    }
}
