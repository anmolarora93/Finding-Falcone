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
    
    private init() {}
    
    func makeRequest(url: URL) async -> NetworkRequestResponse {
        do {
            let response: Response? = try await session?.data(from: url)
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
