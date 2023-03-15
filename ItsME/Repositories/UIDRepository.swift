//
//  KeychainRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/14.
//

import Foundation

final class UIDRepository {
    
    typealias UID = String
    
    static var shared: UIDRepository = .init()
    
    private init() {}
    
    var bundleIdentifier: String? {
        Bundle.main.bundleIdentifier
    }
    var account: String {
        "UID"
    }
    var dataEncodingType: String.Encoding {
        .utf8
    }
}

// MARK: - API

extension UIDRepository {
    
    func saveUID(_ uid: UID, _ completion: ((OSStatus) -> Void)? = nil) {
        guard let uidData = uid.data(using: dataEncodingType) else {
            completion?(errSecInvalidEncoding)
            return
        }
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrService: bundleIdentifier as Any,
                                kSecAttrAccount: account,
                                  kSecValueData: uidData]
        DispatchQueue.global().async {
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecDuplicateItem {
                self.updateUID(uidData, completion)
                return
            }
            completion?(status)
        }
    }
    
    func removeUID(_ completion: ((OSStatus) -> Void)? = nil) {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrService: bundleIdentifier as Any,
                                kSecAttrAccount: account]
        DispatchQueue.global().async {
            let status = SecItemDelete(query as CFDictionary)
            completion?(status)
        }
    }
    
    func getUID(_ completion: @escaping ((OSStatus, UID?) -> Void)) {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrService: bundleIdentifier as Any,
                                kSecAttrAccount: account,
                                 kSecReturnData: true]
        var result: CFTypeRef?
        
        DispatchQueue.global().async {
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            
            guard let data = result as? Data else {
                return completion(status, nil)
            }
            
            let uid = UID.init(data: data, encoding: self.dataEncodingType)
            return completion(status, uid)
        }
    }
    
    func updateUID(_ uidData: Data, _ completion: ((OSStatus) -> Void)? = nil) {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                              kSecAttrService: bundleIdentifier as Any]
        let attributes: [CFString: Any] = [kSecAttrAccount: account,
                                             kSecValueData: uidData]
        DispatchQueue.global().async {
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            completion?(status)
        }
    }
    
    func updateUID(_ uid: UID, _ completion: ((OSStatus) -> Void)? = nil) {
        guard let uidData = uid.data(using: dataEncodingType) else {
            completion?(errSecInvalidEncoding)
            return
        }
        
        updateUID(uidData, completion)
    }
}
