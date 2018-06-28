//
//  ShoppingListCell.swift
//  roomiesapp
//
//  Created by Gebruiker on 27-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit
protocol ShoppingListCellDelegate : class {
    func didPressButton(sender: ShoppingListCell)
}

class ShoppingListCell: UITableViewCell {
    var delegate: ShoppingListCellDelegate?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        delegate?.didPressButton(sender: self)
    }
    
}
