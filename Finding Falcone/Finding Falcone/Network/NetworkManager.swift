//
//  NetworkManager.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import Foundation

typealias NetworkRequestResponse = (data: Data?, error: AppError?)
typealias Response = (data: Data?, urlResponse: URLResponse)

final class NetworkManager {
    static var shared = NetworkManager()
    
    private var session: URLSession?
    
    private init() {
        self.session = URLSession(configuration: .default)
    }
    
    func makeRequest(urlRequest: URLRequest) async -> NetworkRequestResponse {
        do {
            let response: Response? = try await session?.data(for: urlRequest)
            if let urlResponse = response?.urlResponse as? HTTPURLResponse {
                if 200...209 ~= urlResponse.statusCode {
                    return (response?.data, nil)
                }
            }
        } catch {
            return (nil, AppError(localizedDescription: error.localizedDescription))
        }
        return (nil, AppError(localizedDescription: "Something Went Wrong"))
    }
}
