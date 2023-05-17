//
//  OSStatus+ToReadableString.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/14.
//

import Foundation

extension OSStatus {
    
    /// `OSStatus` 코드를 읽을 수 있는 문자열로 만들어 반환합니다.
    public var toReadableString: String? {
        return SecCopyErrorMessageString(self, nil) as? String
    }
}
