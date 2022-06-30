//
//  OptionsViewController.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 29/06/22.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView?
    var viewData: OptionsScreenViewData?
    weak var delegate: OptionsControllerToHomeScreenDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.title = getTitleForNavBar()
    }
}

extension OptionsViewController {
    func getTitleForNavBar() -> String {
        switch viewData?.pickerType {
        case .selectDestination:
            return AppConstants.chooseDestination
        case .selectVehicle:
            return AppConstants.chooseVehicle
        case .none:
            return ""
        }
    }
}

extension OptionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewData?.datasource.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewData?.datasource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let pickerType = self.viewData?.pickerType, let data = viewData?.datasource[row], let indexPath = self.viewData?.indexPath {
            delegate?.selectedValueFromPicker(data, pickerType: pickerType, at: indexPath)
        }
        self.dismiss(animated: true)
    }
}
