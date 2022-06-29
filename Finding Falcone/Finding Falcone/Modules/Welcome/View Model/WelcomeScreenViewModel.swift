//
//  WelcomeScreenViewModel.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import Foundation
import Combine

class WelcomeScreenViewModel {
    
    private var keychainManager: KeyChainManager
    private var coreDataManager: CoreDataManager
    private var tokenService: TokenService
    private var planetService: PlanetService
    private var vehicleService: VehicleService
    @Published var isDataPresentLocally: Bool?
    @Published var isDataProcessed: Bool?
    
    init() {
        self.keychainManager = KeyChainManager.shared
        self.coreDataManager = CoreDataManager.shared
        self.tokenService = TokenService()
        self.planetService = PlanetService()
        self.vehicleService = VehicleService()
    }
    
    func startGame() {
        if !self.checkIfDataExists() {
            Task(priority: .medium) {
                await self.fetchToken()
                await self.fetchPlanets()
                await self.fetchVehicles()
                self.isDataProcessed = true
            }
        } else {
            self.isDataPresentLocally = true
        }
    }
    
    private func checkIfDataExists() -> Bool {
        return isUserAuthenticated() && isPlanetsDataPresent() && isVehicleDataPresent()
    }
    
    private func isUserAuthenticated() -> Bool {
        UserDefaultsManager.isUserAuthenticated
    }
    
    private func isPlanetsDataPresent() -> Bool {
        self.coreDataManager.fetchAllRecordsForEntity(entity: ManagedPlanet.self)?.count == 6
    }
    
    private func isVehicleDataPresent() -> Bool {
        self.coreDataManager.fetchAllRecordsForEntity(entity: ManagedVehicle.self)?.count == 4
    }
    
    // MARK: - Token
    private func fetchToken() async {
        let token = await self.tokenService.fetchToken()
        self.saveToken(token: token)
    }
    
    private func saveToken(token: Token?) {
        guard let token = token, let tokenData = token.token.data(using: .utf8) else { return }
        self.keychainManager.save(tokenData)
        UserDefaultsManager.isUserAuthenticated = true
    }
    
    // MARK: - Planets
    private func fetchPlanets() async {
        let planets = await self.planetService.fetchPlanets()
        self.savePlanetsInDB(planets: planets)
    }
    
    private func savePlanetsInDB(planets: [Planets]?) {
        guard let planets = planets else { return }
        planets.forEach({
            if let planetEntity = self.coreDataManager.createEntity(entity: ManagedPlanet.self) as? ManagedPlanet {
                planetEntity.name = $0.name
                planetEntity.distance = Int64($0.distance)
                self.coreDataManager.saveMainContext()
            }
        })
    }
    
    // MARK: - Vehicle
    private func fetchVehicles() async {
        let vehicles = await self.vehicleService.fetchVehicles()
        self.saveVehiclesInDB(vehicles: vehicles)
    }
    
    private func saveVehiclesInDB(vehicles: [Vehicle]?) {
        guard let vehicles = vehicles else { return }
        vehicles.forEach({
            if let vehicleEntity = self.coreDataManager.createEntity(entity: ManagedVehicle.self) as? ManagedVehicle {
                vehicleEntity.name = $0.name
                vehicleEntity.totalNumber = Int16($0.totalNumber ?? -1)
                vehicleEntity.maxDistance = Int32($0.maxDistance ?? -1)
                vehicleEntity.speed = Int32($0.speed ?? -1)
                self.coreDataManager.saveMainContext()
            }
        })
    }
}
