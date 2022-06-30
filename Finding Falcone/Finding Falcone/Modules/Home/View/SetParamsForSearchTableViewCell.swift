//
//  SetParamsForSearchTableViewCell.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import UIKit

class SetParamsForSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var selectDestinationLabel: UILabel!
    @IBOutlet weak var selectedDestinationNameLabel: UILabel?
    @IBOutlet weak var separatorView: UIView?
    @IBOutlet weak var selectVehicleLabel: UILabel!
    @IBOutlet weak var selectedVehicleNameLabel: UILabel?
    
    @IBAction func selectDestinationButtonPressed() {
        delegate?.selectDestinationButtonPressed(at: indexPath)
    }
    
    @IBAction func selectVehicleButtonPressed() {
        delegate?.selectVehicleButtonPressed(at: indexPath)
    }
    
    weak var delegate: ParamsCellToHomeScreenDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configureCell(destination: String?, vehicleName: String?, at indexPath: IndexPath) {
        self.indexPath = indexPath
        self.selectedDestinationNameLabel?.text = destination ?? ""
        self.selectedVehicleNameLabel?.text = vehicleName ?? ""
    }
}
