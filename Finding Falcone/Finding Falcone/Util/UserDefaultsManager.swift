//
//  UserDefaultsManager.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 29/06/22.
//

import Foundation

class UserDefaultsManager {
    enum Keys: String {
        case isUserAuthenticated
    }
    
    @Storage(key: UserDefaultsManager.Keys.isUserAuthenticated.rawValue, defaultValue: false)
    static var isUserAuthenticated: Bool
}
