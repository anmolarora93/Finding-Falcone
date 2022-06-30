//
//  FindFalconeService.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 29/06/22.
//

import Foundation
import os.log

class FindFalconeService {
    private var networkManager: NetworkManager?
    private var request: Requests
    private var decoder: JSONDecoder?
    
    init() {
        self.networkManager = NetworkManager.shared
        self.request = .findFalcone
        self.decoder = JSONDecoder()
    }
    
    func findFalcone(using data: [String: Any]) async -> FindingFalconeResponse? {
        guard let url = URL(string: self.request.url) else { fatalError("Error Forming URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.requestType.rawValue
        urlRequest.addValue(AppConstants.applicationJson, forHTTPHeaderField: AppConstants.accept)
        urlRequest.addValue(AppConstants.applicationJson, forHTTPHeaderField: AppConstants.contentType)
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        } catch let error {
            os_log("Error While Serializing Data: %@", type: .error, error.localizedDescription)
            return nil
        }
        
        let response = await self.networkManager?.makeRequest(urlRequest: urlRequest)
        
        if let data = response?.data {
            do {
                let token = try decoder?.decode(FindingFalconeResponse.self, from: data)
                return token
            } catch {
                print(error.localizedDescription)
            }
            
        }
        return nil
    }
}
