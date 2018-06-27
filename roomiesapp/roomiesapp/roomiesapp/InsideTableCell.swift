//
//  InsideTableCell.swift
//  roomiesapp
//
//  Created by Gebruiker on 27-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import UIKit

protocol InsideTableCellDelegate : class {
    func SwitchEnabled(sender: InsideTableCell)
}

class InsideTableCell: UITableViewCell {
    var delegate: InsideTableCellDelegate?
    
    @IBAction func ValueChange(_ sender: UISwitch) {
        delegate?.SwitchEnabled(sender: self)
    }
    
    
    @IBOutlet weak var SwitchButton: UISwitch!
    @IBOutlet weak var TitleCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
