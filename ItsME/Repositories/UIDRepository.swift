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
    
    /// 현재 앱을 구분하는데 사용되는 값입니다.
    ///
    /// 기본 값으로 `Bundle Identifier` 가 사용됩니다.
    var service: String? {
        Bundle.main.bundleIdentifier
    }
    
    /// `UID` 데이터에 해당하는 키 값입니다.
    var keyOfUID: String {
        "UID"
    }
    
    /// 키체인에 데이터를 저장할 때 사용되는 인코딩 타입입니다.
    var dataEncodingType: String.Encoding {
        .utf8
    }
}

// MARK: - API

extension UIDRepository {
    
    /// 주어진 `UID` 를 키체인에 저장한 뒤 `completion` 이 호출됩니다.
    ///
    /// 이미 키체인에 `UID` 가 존재하는 경우 기존 값을 업데이트한 뒤 `completion` 이 호출됩니다.
    ///
    /// 이 함수는 메인쓰레드에서 실행되지 않습니다.
    ///
    /// - Parameter uid: 키체인에 저장할 UID
    /// - Parameter completion: 성공적으로 키체인에 저장되면 매개변수로 `errSecSuccess` 값이 전달됩니다. 저장에 실패할 경우 실패 원인에 대한 `OSStatus` 값이 전달됩니다.
    func saveUID(_ uid: UID, _ completion: ((OSStatus) -> Void)? = nil) {
        guard let uidData = uid.data(using: dataEncodingType) else {
            completion?(errSecInvalidEncoding)
            return
        }
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrService: service as Any,
                                kSecAttrAccount: keyOfUID,
                                  kSecValueData: uidData]
        DispatchQueue.global().async {
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecDuplicateItem {
                self.updateUIDData(uidData, completion)
                return
            }
            completion?(status)
        }
    }
    
    /// 키체인에 존재하는 `UID` 를 삭제한 뒤 `completion` 이 호출됩니다.
    ///
    /// 이 함수는 메인쓰레드에서 실행되지 않습니다.
    ///
    /// - Parameter completion: 성공적으로 키체인에서 UID 가 삭제되면 매개변수로 `errSecSuccess` 값이 전달됩니다. 삭제에 실패할 경우 실패 원인에 대한 `OSStatus` 값이 전달됩니다.
    func removeUID(_ completion: ((OSStatus) -> Void)? = nil) {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrService: service as Any,
                                kSecAttrAccount: keyOfUID]
        DispatchQueue.global().async {
            let status = SecItemDelete(query as CFDictionary)
            completion?(status)
        }
    }
    
    /// 키체인에 `UID` 가 존재할 경우 `UID` 매개변수에 값을 담아 `completion` 이 호출됩니다.
    ///
    /// 키체인에 `UID` 가 존재하지 않을 경우 `UID` 매개변수에 nil 이 담긴 `completion` 이 호출됩니다.
    ///
    /// 이 함수는 메인쓰레드에서 실행되지 않습니다.
    func getUID(_ completion: @escaping ((OSStatus, UID?) -> Void)) {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrService: service as Any,
                                kSecAttrAccount: keyOfUID,
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
    
    /// 주어진 `UIDData` 로 키체인 저장된 `UID` 를 업데이트한 뒤 `completion` 이 호출됩니다.
    ///
    /// 이 함수는 메인쓰레드에서 실행되지 않습니다.
    ///
    /// - Parameter uidData: 키체인에 업데이트할 `UID Data`
    /// - Parameter completion: 성공적으로 키체인에 `UID Data` 가 업데이트될 경우 매개변수로 `errSecSuccess` 값이 전달됩니다. 업데이트에 실패할 경우 실패 원인에 대한 `OSStatus` 값이 전달됩니다.
    func updateUIDData(_ data: Data, _ completion: ((OSStatus) -> Void)? = nil) {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrService: service as Any,
                                kSecAttrAccount: keyOfUID]
        let updateAttributes: [CFString: Any] = [kSecValueData: data]
        DispatchQueue.global().async {
            let status = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)
            completion?(status)
        }
    }
    
    /// 주어진 `UID` 로 키체인 저장된 `UID` 를 업데이트한 뒤 `completion` 이 호출됩니다.
    ///
    /// 이 함수는 내부적으로 `updateUIDData(_:_:)` 를 호출합니다.
    ///
    /// 이 함수는 메인쓰레드에서 실행되지 않습니다.
    ///
    /// - Parameter uid: 키체인에 업데이트할 `UID`
    /// - Parameter completion: 성공적으로 키체인에 `UID` 가 업데이트될 경우 매개변수로 `errSecSuccess` 값이 전달됩니다. 업데이트에 실패할 경우 실패 원인에 대한 `OSStatus` 값이 전달됩니다.
    func updateUID(_ uid: UID, _ completion: ((OSStatus) -> Void)? = nil) {
        guard let uidData = uid.data(using: dataEncodingType) else {
            completion?(errSecInvalidEncoding)
            return
        }
        
        updateUIDData(uidData, completion)
    }
}
