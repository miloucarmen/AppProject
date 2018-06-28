//
//  CalendarCollectionViewCell.swift
//  roomiesapp
//
//  Created by Gebruiker on 28-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import UIKit

protocol CalendarCellDelegate : class {
    func didPressButton(sender: CalendarCollectionViewCell)
}

class CalendarCollectionViewCell: UICollectionViewCell {
    var delegate: CalendarCellDelegate?

    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        delegate?.didPressButton(sender: self)
    }
    
    
}
