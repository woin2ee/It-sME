//
//  Hash.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/03.
//

import CryptoKit
import Foundation

/// 주어진 문자열에 `SHA256` 해시 함수를 적용하여 `Hexadecimal String` 으로 반환합니다.
/// - Parameter input: <#input description#>
/// - Returns: <#description#>
@available(iOS 13, *)
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let digest = SHA256.hash(data: inputData)
    let hexadecimalString = digest.map {
        String(format: "%02x", $0)
    }.joined()
    
    return hexadecimalString
}
