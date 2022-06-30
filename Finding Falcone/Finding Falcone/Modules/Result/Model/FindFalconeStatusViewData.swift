//
//  FindFalconeStatusViewData.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 30/06/22.
//

import Foundation

class FindFalconeStatusViewData {
    var apiStatus: FindingFalconeResponse?
    var timeTaken: Int?
    
    init(apiStatus: FindingFalconeResponse?, timeTaken: Int?) {
        self.apiStatus = apiStatus
        self.timeTaken = timeTaken
    }
}
