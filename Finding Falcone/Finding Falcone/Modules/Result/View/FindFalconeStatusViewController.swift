//
//  FindFalconeStatusViewController.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 30/06/22.
//

import UIKit
import os.log

class FindFalconeStatusViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var planetFoundLabel: UILabel!
    
    @IBAction func startOverButtonPressed() {
        delegate?.playAgainButtonPressed()
        self.dismiss(animated: true)
    }
    
    var viewData: FindFalconeStatusViewData?
    weak var delegate: StatusControllerToHomeScreenDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureUI()
    }
    
    func configureUI() {
        guard let viewData = viewData else { return }
        if let status = viewData.apiStatus?.status {
            switch(ResponseStatus(rawValue: status)) {
            case .success:
                self.configureUIForSucess(data: viewData)
            case .failure:
                self.configureUIForFailure(data: viewData)
            case .error:
                self.configureUIForError(data: viewData)
            case .none:
                os_log("Unreachable Code", type: .info)
            }
        }
    }
    
    func configureUIForSucess(data: FindFalconeStatusViewData) {
        self.statusLabel.text = AppConstants.success
        self.timeTakenLabel.text = "Time Taken: \(data.timeTaken ?? 0)"
        self.planetFoundLabel.text = "Planet Found: \(data.apiStatus?.planetName ?? "")"
    }
    
    func configureUIForFailure(data: FindFalconeStatusViewData) {
        self.statusLabel.text = AppConstants.failure
        self.timeTakenLabel.text = "Time Taken: \(data.timeTaken ?? 0)"
        self.planetFoundLabel.isHidden = true
    }
    
    func configureUIForError(data: FindFalconeStatusViewData) {
        self.statusLabel.text = data.apiStatus?.status
        [self.timeTakenLabel, self.planetFoundLabel].forEach({
            $0?.isHidden = true
        })
    }
}
