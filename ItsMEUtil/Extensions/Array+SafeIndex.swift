//
//  Array+SafeIndex.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/13.
//

import Foundation

extension Array {
    
    /// 배열에 해당 인덱스가 존재할 경우 해당 인덱스의 값을 반환합니다. 그렇지 않을 경우 nil 을 반환합니다.
    public subscript(ifExists index: Index) -> Element? {
        get {
            guard self.indices ~= index else {
                #if DEBUG
                    ItsMELogger.standard.error("Out of index. >>> \(self.debugDescription)")
                #endif
                return nil
            }
            
            return self[index]
        }
    }
}
