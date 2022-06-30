//
//  HomeScreenViewModel.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 29/06/22.
//

import Foundation
import Combine

class HomeScreenViewModel {
    private var coreDataManager: CoreDataManager
    private var keychainManager: KeyChainManager
    private var homeScreenViewData: HomeScreenViewModelData
    private var falconeSearchPlanets = [Int: String]()
    private var falconeSearchVehicle = [Int: String]()
    private var findFalconeService: FindFalconeService
    @Published var isDataComplete: Bool?
    @Published var serviceReturnedData: FindingFalconeResponse?
    
    init() {
        self.coreDataManager = CoreDataManager.shared
        self.keychainManager = KeyChainManager.shared
        self.homeScreenViewData = HomeScreenViewModelData()
        self.findFalconeService = FindFalconeService()
    }
    
    func homeScreenDidLoad() {
        self.fetchDataFromLocal()
    }
}

// MARK: - Fetch Data
private extension HomeScreenViewModel {
    private func fetchDataFromLocal() {
        self.fetchToken()
        self.fetchPlanetsData()
        self.fetchVehicleData()
    }
    
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

// MARK: - Save Data Coming from UI/ Create Data for Display on UI
extension HomeScreenViewModel {
    func fetchDataForPlanetPickerView() -> [String]? {
        let planets = self.homeScreenViewData.planets
        if falconeSearchPlanets.isEmpty {
            return planets.map({$0.map({$0.name})})
        } else {
            let selectedPlanets = falconeSearchPlanets.values
            return planets?.filter({!selectedPlanets.contains($0.name)}).map({$0.name})
        }
    }
    
    func fetchDataForVehiclePickerView(destination: Int) -> [String]? {
        let selectedPlanet = falconeSearchPlanets[destination]
        if selectedPlanet == nil { return nil }
        let distanceOfSelectedPlanet = self.homeScreenViewData.planets?.filter({$0.name == selectedPlanet}).first?.distance ?? 0
        let vehicles = homeScreenViewData.vehicles
        return vehicles?.filter({$0.maxDistance >= distanceOfSelectedPlanet}).map{($0.name)}
    }
    
    func setSelectedPlanet(_ planet: String, for destination: Int) {
        self.falconeSearchPlanets[destination] = planet
    }
    
    func setSelectedVehicle(_ vehicle: String, for destination: Int) {
        self.falconeSearchVehicle[destination] = vehicle
    }
    
    func getPlanetForDestination(_ destination: Int) -> String? {
        falconeSearchPlanets[destination]
    }
    
    func getVehicleForDestination(_ destination: Int) -> String? {
        falconeSearchVehicle[destination]
    }
}

// MARK: - Create Data for API
extension HomeScreenViewModel {
    func prepareDataToSend() {
        let selectedPlanets = falconeSearchPlanets.map({$0.value})
        let selectedvehicles = falconeSearchVehicle.map({$0.value})
        let token = self.homeScreenViewData.token
        
        if token == nil || selectedPlanets.count == 0 || selectedvehicles.count == 0 {
            isDataComplete = false
        } else if let token = token {
            self.calculateTime()
            let jsonData:[String: Any] = [AppConstants.apiRequestConstantToken: token,
                                          AppConstants.apiRequestConstantPlanetName: selectedPlanets,
                                          AppConstants.apiRequestConstantVehicleName: selectedvehicles
            ]
            isDataComplete = true
            Task(priority: .high) {
                await sendDataToService(data: jsonData)
            }
        }
    }
    
    func sendDataToService(data: [String: Any]) async {
        let response = await self.findFalconeService.findFalcone(using: data)
        serviceReturnedData = response
    }
    
    func fetchTime() -> Int? {
        self.homeScreenViewData.totalTimeTaken
    }
    
    func calculateTime() {
        let distances = self.calculateDistance()
        let speed = self.calculateSpeed()
        var time: Int = 0
        zip(distances, speed).forEach({
            time += ($0/$1)
        })
        self.homeScreenViewData.totalTimeTaken = time
    }
    
    private func calculateDistance() -> [Int] {
        let selectedPlanets = self.falconeSearchPlanets.map({$0.value})
        var distances = [Int]()
        selectedPlanets.forEach({ (planetName) in
            distances.append(homeScreenViewData.planets?.filter({$0.name == planetName}).first?.distance ?? -1)
        })
        return distances
    }
    
    private func calculateSpeed() -> [Int] {
        let selectedVehicles = self.falconeSearchVehicle.map({$0.value})
        var speeds = [Int]()
        selectedVehicles.forEach({ (vehicleName) in
            speeds.append(homeScreenViewData.vehicles?.filter({$0.name == vehicleName}).first?.speed ?? -1)
        })
        return speeds
    }
}

// MARK: - Reset Game
extension HomeScreenViewModel {
    func resetGame() {
        self.falconeSearchPlanets.removeAll()
        self.falconeSearchVehicle.removeAll()
    }
}
