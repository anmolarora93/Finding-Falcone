//
//  FindingFalcone.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import Foundation

class FindingFalconeResponse {
    var success: Success?
    var failure: Failure?
    var error: Error?
}

class Success: Codable {
    var planetName: String
    var status: String?
}

extension Success {
    enum CodingKeys: String, CodingKey {
        case planetName = "planet_name"
    }
}

class Failure: Codable {
    var status: String
}

class Error: Codable {
    var error: String
}



