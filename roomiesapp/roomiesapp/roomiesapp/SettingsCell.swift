//
//  SettingsCell.swift
//  Has Label and button for settingcell
//  Has protocol for when button is pressed
//

import UIKit


protocol SettingsCellDelegate : class {
    func didPressButton(sender: SettingsCell)
}

class SettingsCell: UITableViewCell {
    var delegate: SettingsCellDelegate?
    
    @IBOutlet weak var TitleCell: UILabel!
    @IBOutlet weak var Button: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton)
    {
        delegate?.didPressButton(sender: self)
    }
    
}
