//
//  DefaultJsonDecoder.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/01.
//

import Foundation

enum JSONSerializationError: Error {
    case invalidJSONObject
}

struct LoggedJsonDecoder {
    
    private init() {}
    
    static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            #if DEBUG
                debugPrint("Fail decode. \(error)")
            #endif
            throw error
        }
    }
    
    static func decode<T>(_ type: T.Type, withJSONObject jsonObject: Any?) throws -> T where T: Decodable {
        let jsonObject = jsonObject as Any
        
        guard JSONSerialization.isValidJSONObject(jsonObject) else {
            #if DEBUG
                debugPrint("Invalid json object. \(jsonObject)")
            #endif
            throw JSONSerializationError.invalidJSONObject
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
        return try self.decode(type, from: jsonData)
    }
}
