//
//  HomeScreenViewController.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import UIKit
import Combine

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    
    @IBAction func findFalconeButtonPressed() {
        self.findFalcone()
    }
    
    private var viewModel: HomeScreenViewModel?
    let sectionHeaders: [String] = AppConstants.sectionHeaders
    private var progressHUD: ProgressHUD?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.homeScreenLoaded()
    }
}

extension HomeScreenViewController {
    func bindViewModel() {
        self.viewModel = HomeScreenViewModel()
        self.viewModel?.$isDataComplete.sink(receiveValue: { (isDataComplete) in
            if let isDataComplete = isDataComplete, isDataComplete {
                self.startProcessing()
            } else {
                self.presentAlertController(title: AppConstants.missingData, message: AppConstants.incompleteForm, buttonText: AppConstants.okButtonText)
            }
        }).store(in: &cancellables)
        
        self.viewModel?.$serviceReturnedData.sink(receiveValue: { (data) in
            DispatchQueue.main.async {
                self.removeSpinnerView()
                self.presentStatusScreen(with: data)
            }
        }).store(in: &cancellables)
    }
    
    func homeScreenLoaded() {
        self.viewModel?.homeScreenDidLoad()
    }
    
    func getOptionsNavController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let optionsNavVC = storyboard.instantiateViewController(withIdentifier: AppConstants.optionsNavVC) as? UINavigationController
        return optionsNavVC
    }
    
    func presentAlertController(title: String, message: String, buttonText: String) {
        let okAction = UIAlertAction(title: buttonText, style: .default)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func findFalcone() {
        self.viewModel?.prepareDataToSend()
    }
    
    func startProcessing() {
        self.configureSpinnerView()
        self.addSpinnerView()
    }
    
    func configureSpinnerView() {
        progressHUD = ProgressHUD(text: AppConstants.fndingFalcone)
    }
    
    func addSpinnerView() {
        guard let progressHUD = self.progressHUD else { return }
        self.view.addSubview(progressHUD)
    }
    
    func removeSpinnerView() {
        guard let progressHUD = self.progressHUD else { return }
        progressHUD.removeFromSuperview()
    }
    
    func presentStatusScreen(with data: FindingFalconeResponse?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let statusVC = storyboard.instantiateViewController(withIdentifier: String(describing: FindFalconeStatusViewController.self)) as? FindFalconeStatusViewController {
            statusVC.viewData = FindFalconeStatusViewData(apiStatus: data, timeTaken: self.viewModel?.fetchTime())
            statusVC.delegate = self
            statusVC.modalPresentationStyle = .fullScreen
            self.present(statusVC, animated: true)
        }
    }
}

extension HomeScreenViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SetParamsForSearchTableViewCell.self), for: indexPath) as? SetParamsForSearchTableViewCell {
            cell.delegate = self
            cell.configureCell(destination: self.viewModel?.getPlanetForDestination(indexPath.section), vehicleName: self.viewModel?.getVehicleForDestination(indexPath.section), at: indexPath)
            return cell
        }
        return UITableViewCell()
    }
}

extension HomeScreenViewController: ParamsCellToHomeScreenDelegate {
    func selectDestinationButtonPressed(at indexPath: IndexPath) {
        if let optionsNavVC = getOptionsNavController(), let optionsVC = optionsNavVC.viewControllers.first as? OptionsViewController, let datasource = self.viewModel?.fetchDataForPlanetPickerView() {
            let optionsScreenData = OptionsScreenViewData(datasource: datasource, indexPath: indexPath, pickerType: .selectDestination)
            optionsVC.viewData = optionsScreenData
            optionsVC.delegate = self
            self.present(optionsNavVC, animated: true)
        }
    }
    
    func selectVehicleButtonPressed(at indexPath: IndexPath) {
        if let optionsNavVC = getOptionsNavController(), let optionsVC = optionsNavVC.viewControllers.first as? OptionsViewController {
            if let datasource = self.viewModel?.fetchDataForVehiclePickerView(destination: indexPath.section) {
                let optionsScreenData = OptionsScreenViewData(datasource: datasource, indexPath: indexPath, pickerType: .selectVehicle)
                optionsVC.viewData = optionsScreenData
                optionsVC.delegate = self
                self.present(optionsNavVC, animated: true)
            } else {
                self.presentAlertController(title: AppConstants.missingData, message: AppConstants.selectDestination, buttonText: AppConstants.okButtonText)
            }
        }
    }
}

extension HomeScreenViewController: OptionsControllerToHomeScreenDelegate {
    func selectedValueFromPicker(_ value: String, pickerType: PickerType, at: IndexPath) {
        switch pickerType {
        case .selectDestination:
            self.viewModel?.setSelectedPlanet(value, for: at.section)
        case .selectVehicle:
            self.viewModel?.setSelectedVehicle(value, for: at.section)
        }
        self.tableView?.reloadRows(at: [at], with: .none)
    }
}

extension HomeScreenViewController: StatusControllerToHomeScreenDelegate {
    func playAgainButtonPressed() {
        self.viewModel?.resetGame()
        self.tableView?.reloadData()
    }
}
