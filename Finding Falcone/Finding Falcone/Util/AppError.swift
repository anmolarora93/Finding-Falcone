//
//  AppError.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import Foundation

struct AppError {
    var errorCode: Int?
    var localizedDescription: String?
    
    init(errorCode: Int, localizedDescription: String) {
        self.errorCode = errorCode
        self.localizedDescription = localizedDescription
    }
    
    init(localizedDescription: String) {
        self.errorCode = nil
        self.localizedDescription = localizedDescription
    }
}
