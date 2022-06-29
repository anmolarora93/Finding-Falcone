//
//  WelcomeScreenViewController.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import UIKit

class WelcomeScreenViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel?
    @IBOutlet weak var falconeImageView: UIImageView?
    @IBOutlet weak var getStartedButton: UIButton?
    
    @IBAction func getStartedButtonPressed() {
        viewModel.startGame()
    }
    
    private let viewModel = WelcomeScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
