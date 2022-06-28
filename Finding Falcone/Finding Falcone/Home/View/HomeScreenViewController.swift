//
//  HomeScreenViewController.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    
    let sectionHeaders: [String] = ["Destination 1",
                                    "Destination 2",
                                    "Destination 3",
                                    "Destination 4"]
    override func viewDidLoad() {
        super.viewDidLoad()
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
