//
//  KeyChainManager.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 29/06/22.
//

import Foundation
import os.log

final class KeyChainManager {
    static let shared = KeyChainManager()
    
    private init() {}
    
    func save(_ data: Data, service: String = AppConstants.serviceName, account: String = AppConstants.account) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        switch status {
        case errSecSuccess:
            os_log("Saved Successfully", type: .info)
        case errSecDuplicateItem:
            os_log("Token Already Exists....Replacing", type: .info)
            self.updateData(data: data, service: service, account: account)
        default:
            os_log("Error while saving to Keychain: %@", type: .error, status)
        }
    }
    
    private func updateData(data: Data, service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        let attributesToUpdate = [kSecValueData: data] as CFDictionary
        SecItemUpdate(query, attributesToUpdate)
    }
    
    func retrieve(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return (result as? Data)
    }
}
