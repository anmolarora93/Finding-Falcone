//
//  SetParamsForSearchTableViewCell.swift
//  Finding Falcone
//
//  Created by Anmol Arora on 28/06/22.
//

import UIKit

class SetParamsForSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var selectDestinationLabel: UILabel!
    @IBOutlet weak var selectDestinationPickerView: UIPickerView?
    @IBOutlet weak var selectVehicleLabel: UILabel!
    @IBOutlet weak var selectVehiclePickerView: UIPickerView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
