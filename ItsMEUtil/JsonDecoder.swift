//
//  JsonDecoder.swift
//  ItsMEUtil
//
//  Created by Jaewon Yun on 2023/05/17.
//

import Foundation

public struct LoggedJsonDecoder {
    
    private init() {}
    
    public static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            #if DEBUG
                ItsMELogger.standard.error("Fail decode. \(error)")
            #endif
            throw error
        }
    }
    
    public static func decode<T>(_ type: T.Type, withJSONObject jsonObject: Any?) throws -> T where T: Decodable {
        let jsonObject = jsonObject as Any
        
        guard JSONSerialization.isValidJSONObject(jsonObject) else {
            #if DEBUG
                ItsMELogger.standard.error("Invalid json object. \(type)")
            #endif
            throw JSONSerializationError.invalidJSONObject
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
        return try self.decode(type, from: jsonData)
    }
}

// MARK: - Error

extension LoggedJsonDecoder {
    
    enum JSONSerializationError: Error {
        case invalidJSONObject
    }
}
