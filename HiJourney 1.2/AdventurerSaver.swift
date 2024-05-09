//
//  AdventurerSaver.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 19.04.24.
//

import Foundation
import Security

struct AdventurerSaver {
    static let service = "com.yourcompany.yourapp"
    
    static func saveAdventurer(_ adventurer: Adventurer) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(adventurer) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: "currentAdventurer",
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary)
            let _ = SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    static func loadAdventurer() -> Adventurer? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "currentAdventurer",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess {
            if let data = result as? Data {
                let decoder = JSONDecoder()
                if let adventurer = try? decoder.decode(Adventurer.self, from: data) {
                    return adventurer
                }
            }
        }
        
        return nil
    }
    
    static func deleteAdventurer() {
           let query: [String: Any] = [
               kSecClass as String: kSecClassGenericPassword,
               kSecAttrService as String: service,
               kSecAttrAccount as String: "currentAdventurer"
           ]
           
           SecItemDelete(query as CFDictionary)
       }
}

struct CreatorSaver {
    static let service = "com.yourcompany.yourapp"
    
    static func saveCreator(_ creator: Creator) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(creator) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: "currentCreator",
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary)
            let _ = SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    static func loadCreator() -> Creator? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "currentCreator",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess {
            if let data = result as? Data {
                let decoder = JSONDecoder()
                if let creator = try? decoder.decode(Creator.self, from: data) {
                    return creator
                }
            }
        }
        
        return nil
    }
    
    static func deleteCreator() {
           let query: [String: Any] = [
               kSecClass as String: kSecClassGenericPassword,
               kSecAttrService as String: service,
               kSecAttrAccount as String: "currentCreator"
           ]
           
           SecItemDelete(query as CFDictionary)
       }
}
