//
//  PlanetService.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import Foundation

class PlanetService {
    private var networkManager: NetworkManager?
    private var request: Requests
    private var decoder: JSONDecoder?
    
    init() {
        self.networkManager = NetworkManager.shared
        self.request = .fetchPlanets
        self.decoder = JSONDecoder()
    }
    
    func fetchPlanets() async -> [Planets]? {
        guard let url = URL(string: self.request.url) else { fatalError("Error Forming URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.requestType.rawValue
        
        let response = await self.networkManager?.makeRequest(urlRequest: urlRequest)
        
        if let data = response?.data {
            let planets = try? decoder?.decode([Planets].self, from: data)
            return planets
        }
        return nil
    }
}
