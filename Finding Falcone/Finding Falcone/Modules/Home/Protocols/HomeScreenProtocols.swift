//
//  HomeScreenProtocols.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 29/06/22.
//

import Foundation

protocol ParamsCellToHomeScreenDelegate: AnyObject {
    func selectDestinationButtonPressed(at indexPath: IndexPath)
    func selectVehicleButtonPressed(at indexPath: IndexPath)
}

protocol OptionsControllerToHomeScreenDelegate: AnyObject {
    func selectedValueFromPicker(_ value: String, pickerType: PickerType, at: IndexPath)
}

protocol StatusControllerToHomeScreenDelegate: AnyObject {
    func playAgainButtonPressed()
}
