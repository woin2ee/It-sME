//
//  ItsMEUtilError.swift
//  ItsMEUtil
//
//  Created by Jaewon Yun on 2023/05/17.
//

import Foundation

enum ItsMEUtilError: Error {
    case castingFailed(object: Any, targetType: Any.Type)
    case nilValue(objectType: Any.Type)
}
