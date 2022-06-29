//
//  HomeScreenViewController.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    
    private var viewModel: HomeScreenViewModel?
    let sectionHeaders: [String] = AppConstants.sectionHeaders
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.homeScreenLoaded()
    }
}

extension HomeScreenViewController {
    func bindViewModel() {
        self.viewModel = HomeScreenViewModel()
    }
    
    func homeScreenLoaded() {
        self.viewModel?.homeScreenDidLoad()
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
            return cell
        }
        return UITableViewCell()
    }
}
