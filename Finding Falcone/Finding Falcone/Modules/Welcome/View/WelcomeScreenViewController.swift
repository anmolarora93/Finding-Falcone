//
//  WelcomeScreenViewController.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import UIKit
import Combine

class WelcomeScreenViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel?
    @IBOutlet weak var falconeImageView: UIImageView?
    @IBOutlet weak var getStartedButton: UIButton?
    
    @IBAction func getStartedButtonPressed() {
        self.startGame()
    }
    
    private var viewModel: WelcomeScreenViewModel?
    private var progressHUD: ProgressHUD?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
}

private extension WelcomeScreenViewController {
    func bindViewModel() {
        self.viewModel = WelcomeScreenViewModel()
        self.viewModel?.$isDataPresentLocally.sink(receiveValue: {
            if $0 ?? false {
                self.presentGameScreen()
            }
        }).store(in: &cancellables)
        
        self.viewModel?.$isDataProcessed.sink(receiveValue: {
            if $0 ?? false {
                self.presentGameScreen()
            }
        }).store(in: &cancellables)
    }
    
    func startGame() {
        self.configureSpinnerView()
        self.addSpinnerView()
        self.viewModel?.startGame()
    }
    
    func configureSpinnerView() {
        progressHUD = ProgressHUD(text: AppConstants.progressHUDText)
    }
    
    func addSpinnerView() {
        guard let progressHUD = self.progressHUD else { return }
        self.view.addSubview(progressHUD)
    }
    
    func removeSpinnerView() {
        guard let progressHUD = self.progressHUD else { return }
        progressHUD.removeFromSuperview()
    }
    
    func presentGameScreenVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let gameScreenNavController = storyboard.instantiateViewController(withIdentifier: AppConstants.gameScreenNavControllerID) as? UINavigationController {
            gameScreenNavController.modalPresentationStyle = .fullScreen
            self.present(gameScreenNavController, animated: true)
        }
    }
    
    func presentGameScreen() {
        DispatchQueue.main.async {
            self.removeSpinnerView()
            self.presentGameScreenVC()
        }
    }
}
