//
//  CurrentUserSession.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 21.02.24.
//

import Foundation
class UserSession: ObservableObject {
    
    
    func saveJWTTokenToKeychain(token: String) -> Bool {
        let tokenData = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "TokenForAuth",
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let deleteResult = SecItemDelete(query as CFDictionary)
        guard deleteResult == errSecSuccess || deleteResult == errSecItemNotFound else {
            print("Error deleting existing token:", deleteResult)
            return false
        }
        
        let resultCode = SecItemAdd(query as CFDictionary, nil)
        guard resultCode == errSecSuccess else {
            print("Error saving token to keychain:", resultCode)
            return false
        }
        
        return true
    }

    func getJWTTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "TokenForAuth",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let resultCode = SecItemCopyMatching(query as CFDictionary, &item)
        guard resultCode == errSecSuccess, let tokenData = item as? Data else {
            print("Error retrieving token from keychain:", resultCode)
            return nil
        }
        
        guard let token = String(data: tokenData, encoding: .utf8) else {
            print("Error decoding token data to string")
            return nil
        }
        
        return token
    }

    
}
