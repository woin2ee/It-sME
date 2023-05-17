//
//  Int+.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/06.
//

import Foundation

extension Int {
    
    /**
    주어진 숫자에 대해 `Leading zero` 방식을 적용한 문자열을 반환합니다.
    
    이미 주어진 숫자의 자릿수가 파라미터로 전달한 `digit` 보다 크다면 주어진 숫자를 그대로 반환합니다.
    
        let leadingZeroString = 3.toLeadingZero(digit: 2)
        // `leadingZeroString` == "03"
    
    - Parameter digit: 표현할 자릿수의 개수입니다.
    - Returns: `Leading zero` 방식이 적용된 문자열
    */
    public func toLeadingZero(digit: UInt) -> String {
        let absNumString = String(abs(self))
        if absNumString.count >= digit {
            return self >= 0 ? absNumString : "-\(absNumString)"
        }
        let leadingZeroString = String(repeating: "0", count: Int(digit) - absNumString.count) + absNumString
        return self >= 0 ? leadingZeroString : "-\(leadingZeroString)"
    }
}
