//
//  InsideTableCell.swift
//  roomiesapp
//
//  
//

import Foundation
import UIKit

@objc protocol InsideTableCellDelegate {
    func SwitchEnabled(sender: InsideTableCell)
}

class InsideTableCell: UITableViewCell {
    
    var delegate: InsideTableCellDelegate?
    
    @IBOutlet weak var SwitchButton: UISwitch!
    @IBOutlet weak var TitleCell: UILabel!
    
    @IBAction func ValueChanged(_ sender: UISwitch) {
        delegate?.SwitchEnabled(sender: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
