//
//  ItsMEError.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/12.
//

import Foundation

enum ItsMEError: Error {
    case castingFailed(object: Any, targetType: Any.Type)
    case nilValue(object: Any?)
}
