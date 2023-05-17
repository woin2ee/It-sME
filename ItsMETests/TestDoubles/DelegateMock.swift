//
//  DelegateMock.swift
//  ItsMENoneHostAppTests
//
//  Created by Jaewon Yun on 2023/05/07.
//

@testable import ItsME
import Foundation

final class DelegateMock {
    
    var didCalledDelegateMethod: Int = 0
}

extension DelegateMock: PhoneNumberEditingViewModelDelegate {
    
    func phoneNumberEditingViewModelDidEndEditing(with phoneNumber: String) {
        didCalledDelegateMethod += 1
    }
}
