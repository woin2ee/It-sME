//
//  KeychainRepository.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/14.
//

import Foundation
import Keychaining

@available(*, deprecated, message: "더 이상 사용되지 않는 객체입니다.")
enum UIDRepositoryError: Error {
    case encodeFail
    case decodeFail
}

@available(*, deprecated, message: "더 이상 사용되지 않는 객체입니다.")
final class UIDRepository {
    
    typealias UID = String
    
    static var shared: UIDRepository = .init()
    
    private init() {}
    
    /// 현재 앱을 구분하는데 사용되는 값입니다.
    ///
    /// 기본 값으로 `Bundle Identifier` 가 사용됩니다.
    var service: String {
        Bundle.main.bundleIdentifier ?? "ItsME"
    }
    
    /// `UID` 데이터에 해당하는 키 값입니다.
    var keyOfUID: String {
        "UID"
    }
    
    /// 키체인에 데이터를 저장할 때 사용되는 인코딩 타입입니다.
    var defaultEncodingType: String.Encoding {
        .utf8
    }
    
    var defaultKeychainQuery: KeychainBasicQuerySetter<KeychainGenericPassword> {
        Keychain.genericPassword.makeBasicQuery()
            .setService(service)
            .setAccount(keyOfUID)
    }
}

// MARK: - API Methods

extension UIDRepository {
    
    func save(_ uid: UID) throws {
        guard let uidData = uid.data(using: defaultEncodingType) else {
            throw UIDRepositoryError.encodeFail
        }
        do {
            try defaultKeychainQuery.forSave
                .setValueType(.data(uidData), forKey: .valueData)
                .execute()
        } catch {
            try defaultKeychainQuery.forUpdate
                .setValueType(.data(uidData), toUpdateForKey: .valueData)
                .execute()
        }
    }
    
    func get() throws -> UID {
        let data = try defaultKeychainQuery.forSearch
            .setReturnType(true, forKey: .returnData)
            .execute()
        guard let uid = UID.init(data: data, encoding: .utf8) else {
            throw UIDRepositoryError.decodeFail
        }
        return uid
    }
    
    func remove() throws {
        try defaultKeychainQuery.forDelete.execute()
    }
}
