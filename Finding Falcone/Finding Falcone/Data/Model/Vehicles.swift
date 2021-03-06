//
//  Vehicles.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import Foundation

class Vehicle: Codable {
    var name: String?
    var totalNumber: Int?
    var maxDistance: Int?
    var speed: Int?
}

extension Vehicle {
    enum CodingKeys: String, CodingKey {
        case name, speed
        case totalNumber = "total_no"
        case maxDistance = "max_distance"
    }
}
