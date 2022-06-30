//
//  FindingFalcone.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import Foundation

class FindingFalconeResponse: Codable {
    var planetName: String
    var status: String?
    var error: String?
}

extension FindingFalconeResponse {
    enum CodingKeys: String, CodingKey {
        case planetName = "planet_name"
        case status
        case error
    }
}
