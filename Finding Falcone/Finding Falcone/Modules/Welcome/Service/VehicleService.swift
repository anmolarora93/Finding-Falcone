//
//  VehicleService.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 29/06/22.
//

import Foundation

class VehicleService {
    private var networkManager: NetworkManager?
    private var request: Requests
    private var decoder: JSONDecoder?
    
    init() {
        self.networkManager = NetworkManager.shared
        self.request = .fetchVehicles
        self.decoder = JSONDecoder()
    }
    
    func fetchVehicles() async -> [Vehicle]? {
        guard let url = URL(string: self.request.url) else { fatalError("Error Forming URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.requestType.rawValue
        
        let response = await self.networkManager?.makeRequest(urlRequest: urlRequest)
        
        if let data = response?.data {
            let vehicle = try? decoder?.decode([Vehicle].self, from: data)
            print(vehicle?.first?.speed)
            return vehicle
        }
        return nil
    }
}

