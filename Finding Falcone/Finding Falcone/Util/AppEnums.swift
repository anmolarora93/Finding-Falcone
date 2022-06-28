//
//  AppEnums.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

enum RequestType: String {
    case GET
    case POST
}

enum Requests {
    case fetchToken
    case fetchPlanets
    case fetchVehicles
    case findFalcone
    
    var url: String {
        switch self {
        case .fetchToken:
            return "https://findfalcone.herokuapp.com/token"
        case.fetchPlanets:
            return "https://findfalcone.herokuapp.com/planets"
        case .fetchVehicles:
            return "https://findfalcone.herokuapp.com/vehicles"
        case .findFalcone:
            return "https://findfalcone.herokuapp.com/find"
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .fetchToken, .findFalcone:
            return .GET
        case .fetchPlanets, .fetchVehicles:
            return .POST
        }
    }
}
