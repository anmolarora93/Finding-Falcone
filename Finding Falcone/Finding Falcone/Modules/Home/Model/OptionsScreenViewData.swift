//
//  OptionsScreenViewData.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 30/06/22.
//

import Foundation

class OptionsScreenViewData {
    var datasource: [String]
    var indexPath: IndexPath
    var pickerType: PickerType
    
    init(datasource: [String], indexPath: IndexPath, pickerType: PickerType) {
        self.datasource = datasource
        self.indexPath = indexPath
        self.pickerType = pickerType
    }
    
}
