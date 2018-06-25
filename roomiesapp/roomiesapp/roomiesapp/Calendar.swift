
//import Foundation
//import UIKit
//
//class ViewCalendar: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    @IBOutlet weak var Calendar: UICollectionView!
//    @IBOutlet weak var monthLabel: UILabel!
//
//
//    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
//
//    let DaysOfMonth = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
//
//    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
//    var currentMonth = String()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        currentMonth = Months[month]
//        monthLabel.text = "\(currentMonth) \(year)"
//    }
//
//
//
//
//    @IBAction func Next(_ sender: Any) {
//    }
//    @IBAction func Previous(_ sender: Any) {
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
