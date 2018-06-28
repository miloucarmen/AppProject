//
//  ShoppingListCell.swift
//  roomiesapp
//
//  Created by Gebruiker on 27-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit

// protecol for when button is pressed
protocol ShoppingListCellDelegate : class {
    func didPressButton(sender: ShoppingListCell)
}

class ShoppingListCell: UITableViewCell {
    
    //delegate created
    var delegate: ShoppingListCellDelegate?
    
    
    // Outlets created
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // calls delegate func
    @IBAction func ButtonPressed(_ sender: UIButton) {
        delegate?.didPressButton(sender: self)
    }
    
}
