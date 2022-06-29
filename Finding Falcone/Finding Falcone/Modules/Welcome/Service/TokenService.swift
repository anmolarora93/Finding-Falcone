//
//  TokenService.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 29/06/22.
//

import Foundation

class TokenService {
    private var networkManager: NetworkManager?
    private var request: Requests
    private var decoder: JSONDecoder?
    
    init() {
        self.networkManager = NetworkManager.shared
        self.request = .fetchToken
        self.decoder = JSONDecoder()
    }
    
    func fetchToken() async -> Token? {
        guard let url = URL(string: self.request.url) else { fatalError("Error Forming URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.requestType.rawValue
        urlRequest.addValue(AppConstants.applicationJson, forHTTPHeaderField: AppConstants.accept)
        
        let response = await self.networkManager?.makeRequest(urlRequest: urlRequest)
        
        if let data = response?.data {
            let token = try? decoder?.decode(Token.self, from: data)
            return token
        }
        return nil
    }
}

