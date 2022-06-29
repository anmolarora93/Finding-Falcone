//
//  HomeScreenViewModelData.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 29/06/22.
//

import Foundation

class HomeScreenViewModelData {
    var planets: [PlanetViewData]?
    var vehicles: [VehicleViewData]?
    var token: String?
}

class PlanetViewData {
    var name: String
    var distance: Int
    
    init(name: String, distance: Int) {
        self.name = name
        self.distance = distance
    }
}

class VehicleViewData {
    var name: String
    var totalNumber: Int
    var maxDistance: Int
    var speed: Int
    
    init(name: String, totalNumber: Int, maxDistance: Int, speed: Int) {
        self.name = name
        self.totalNumber = totalNumber
        self.maxDistance = maxDistance
        self.speed = speed
    }
}
