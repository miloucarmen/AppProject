//
//  CalendarCollectioViewCell
//
//  contains protocol for when button inside collectionview is pressed
//
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
