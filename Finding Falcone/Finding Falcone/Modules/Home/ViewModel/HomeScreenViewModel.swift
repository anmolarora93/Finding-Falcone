//
//  HomeScreenViewModel.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 29/06/22.
//

import Foundation

class HomeScreenViewModel {
    
    private var coreDataManager: CoreDataManager
    private var keychainManager: KeyChainManager
    private var homeScreenViewData: HomeScreenViewModelData
    
    private var selectedPlanets: [String]
    private var selectedVehicles: [String]
    
    init() {
        self.coreDataManager = CoreDataManager.shared
        self.keychainManager = KeyChainManager.shared
        self.homeScreenViewData = HomeScreenViewModelData()
        
        self.selectedPlanets = [String]()
        self.selectedVehicles = [String]()
    }
    
    func homeScreenDidLoad() {
        self.fetchDataFromLocal()
    }
    
    private func fetchDataFromLocal() {
        self.fetchToken()
        self.fetchPlanetsData()
        self.fetchVehicleData()
    }
}

private extension HomeScreenViewModel {
    func fetchToken() {
        if let token = self.keychainManager.retrieve(service: AppConstants.serviceName, account: AppConstants.account), let tokenString = String(data: token, encoding: .utf8) {
            self.homeScreenViewData.token = tokenString
        }
    }
    
    func fetchPlanetsData() {
        var planetsData = [PlanetViewData]()
        if let planets = self.coreDataManager.fetchAllRecordsForEntity(entity: ManagedPlanet.self) {
            planets.forEach({
                if let name = $0.name {
                    planetsData.append(PlanetViewData(name: name, distance: Int($0.distance)))
                }
            })
        }
        self.homeScreenViewData.planets = planetsData
    }
    
    func fetchVehicleData() {
        var vehicleData = [VehicleViewData]()
        if let vehicles = self.coreDataManager.fetchAllRecordsForEntity(entity: ManagedVehicle.self) {
            vehicles.forEach({
                if let name = $0.name {
                    vehicleData.append(VehicleViewData(name: name, totalNumber: Int($0.totalNumber), maxDistance: Int($0.maxDistance), speed: Int($0.speed)))
                }
            })
        }
        self.homeScreenViewData.vehicles = vehicleData
    }
}

extension HomeScreenViewModel {
    func fetchDataForPlanetPickerView() -> [String]? {
        let planets = self.homeScreenViewData.planets
        return planets?.filter({!selectedPlanets.contains($0.name)}).map({$0.name})
    }
}
