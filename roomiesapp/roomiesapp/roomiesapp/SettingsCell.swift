//
//  SettingsCell.swift
//  roomiesapp
//
//  Created by Gebruiker on 19-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
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
