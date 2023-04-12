//
//  UtileFunctions.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/12.
//

import Foundation

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw ItsMEError.castingFailed(object: object, targetType: resultType)
    }
    return returnValue
}
