
import Foundation
import UIKit
import FirebaseDatabase

var eventData = [overallData]()

class ViewCalendar: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CalendarCellDelegate {
    
    // created outlets
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var showEventsTable: UITableView!
    
    // constants
    let monthsList = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    let DaysOfMonth = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let username = Login.UsersInfo.username
    let roommates = Login.UsersInfo.roommates
    let monthNumberList = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    
    // variables
    var daysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonth = String()
    var numberOfEmptyBoxes = Int()
    var nextNumberOfEmptyBoxes = Int()
    var previousNumberOfEmptyBoxes = 0
    var direction = 0
    var positionIndex = 0
    var leapYearIndex = 2
    var dayCounter = 0
    var ref: DatabaseReference!
    var eventController: EventTableViewController!
    

    
    
    // loads beginning view, the current data
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        eventData.append(overallData(roommateOrcurrentUser: username, itemBillOrEvent: [], priceAmountOrStartTime: [], keys: [], withWho: [[]], whoPutInList: []))
        currentMonth = monthsList[month]
        monthLabel.text = "\(currentMonth) \(year)"

        if weekday == 0 {
            weekday = 7
        }
        startDatePosition()
        
        eventController = EventTableViewController()
        showEventsTable.dataSource = eventController
        showEventsTable.delegate = eventController
        
        for (_, name) in roommates.enumerated() {
            ref?.child("\(name)/Events/\(year)-\(monthNumberList[month])-\(day)/").observeSingleEvent(of: .value, with: { (snapshot) in
                if eventData[0].whoPutInList.contains(name) {
                    eventData[0].removeByName(name: name)
                }
                if snapshot.childrenCount > 0 {
                    for events in snapshot.children.allObjects as! [DataSnapshot] {
                        for event in events.children.allObjects as! [DataSnapshot] {
                            eventData[0].AddSorted(addTime: event.key, addEvent: event.value as! String, addWho: name, addKey: events.key)
                        }
                    }
                }
                print(eventData)
                self.showEventsTable.reloadData()
            })
        }
    }

    // calculates white spaces infront of first day of the month
    func startDatePosition() {
        switch direction {
        case 0:
            numberOfEmptyBoxes = weekday
            dayCounter = day
            while dayCounter > 0 {
                numberOfEmptyBoxes = numberOfEmptyBoxes - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBoxes == 0{
                    numberOfEmptyBoxes = 7
                }
            }
            if numberOfEmptyBoxes == 7 {
                numberOfEmptyBoxes = 0
            }
            positionIndex = numberOfEmptyBoxes
        case 1...:
            print(positionIndex)
            nextNumberOfEmptyBoxes = (positionIndex + daysInMonths[month - 1]) % 7
            positionIndex = nextNumberOfEmptyBoxes
            
        case -1:
            previousNumberOfEmptyBoxes = (7 - (daysInMonths[month] - positionIndex) % 7)
            if previousNumberOfEmptyBoxes == 7 {
                previousNumberOfEmptyBoxes = 0
            }
            positionIndex = previousNumberOfEmptyBoxes
            
        default:
            fatalError()
        }
        
    }

    
    // Next en Previous month buttons
    @IBAction func nextMonth(_ sender: Any) {
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            direction = 1
            
            if leapYearIndex < 5 {
                leapYearIndex += 1
            }
            if leapYearIndex == 4 {
                daysInMonths[1] = 29
            }
            if leapYearIndex == 5 {
                leapYearIndex = 1
                daysInMonths[1] = 28
            }
            
            startDatePosition()
            
            currentMonth = monthsList[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        
        default:
            month += 1
            direction = 1
            
            startDatePosition()
            
            currentMonth = monthsList[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            direction = -1
            
            if leapYearIndex > 0 {
                leapYearIndex -= 1
            }
            
            if leapYearIndex == 0 {
                daysInMonths[1] = 29
                leapYearIndex = 4
            } else {
                daysInMonths[1] = 28
            }
            
            startDatePosition()
            
            currentMonth = monthsList[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
            
        default:
            month -= 1
            direction = -1
            
            startDatePosition()
            
            currentMonth = monthsList[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    
    // collection view functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction {
        case 0:
            return daysInMonths[month] + numberOfEmptyBoxes
        case 1...:
            return daysInMonths[month] + nextNumberOfEmptyBoxes
        case -1:
            return daysInMonths[month] + previousNumberOfEmptyBoxes
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! CalendarCollectionViewCell
        cell.buttonLabel.backgroundColor = UIColor.clear
        cell.isHidden = false
        cell.buttonLabel.setTitleColor(.black, for: .normal)
        cell.delegate = self
        switch direction {
        case 0:
            cell.buttonLabel.setTitle("\(indexPath.row + 1 - numberOfEmptyBoxes)", for: .normal)
        case 1...:
            cell.buttonLabel.setTitle("\(indexPath.row + 1 - nextNumberOfEmptyBoxes)", for: .normal)
            
        case -1:
            cell.buttonLabel.setTitle("\(indexPath.row + 1 - previousNumberOfEmptyBoxes)", for: .normal)
           
        default:
            fatalError()
        }
        
        if Int(cell.buttonLabel.title(for: .normal)!)! < 1{
            cell.isHidden = true
        }
        
        // weekend day in grey
        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:
            if Int(cell.buttonLabel.title(for: .normal)!)! > 0 {
                cell.buttonLabel.setTitleColor(.lightGray, for: .normal)
            }
        default:
            break
        }
        
        // marks current day
        if currentMonth == monthsList[calend.component(.month, from: date) - 1] && year == calend.component(.year, from: date) && Int(cell.buttonLabel.title(for: .normal)!)! == day {
            cell.buttonLabel.backgroundColor = .red
        }
        
        return cell
    }
    
    func didPressButton(sender: CalendarCollectionViewCell) {
        
        print(monthNumberList[month])
        
        var dayButton = sender.buttonLabel.title(for: .normal)!
        if Int(dayButton)! < 10 {
            dayButton = "0\(dayButton)"
        }
        print()
        for (_, name) in roommates.enumerated() {
            ref?.child("\(name)/Events/\(year)-\(monthNumberList[month])-\(dayButton)/").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if eventData[0].whoPutInList.contains(name) {
                    eventData[0].removeByName(name: name)
                }
                
                if snapshot.childrenCount > 0 {
                    for events in snapshot.children.allObjects as! [DataSnapshot] {
                        eventData[0].AddKeys(addKeys: events.key)
                        for event in events.children.allObjects as! [DataSnapshot] {
                            eventData[0].AddSorted(addTime: event.key, addEvent: event.value as! String, addWho: name, addKey: events.key)
                        }
                    }
                }
                self.showEventsTable.reloadData()
            })
        }
    }
    
    @IBAction func unwindCalendar(_ sender: UIStoryboardSegue){
        
    }
}




// TableView Class
class EventTableViewController: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventData[0].itemBillOrEvent.count > 0 {
            return eventData[0].itemBillOrEvent.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as? EventTableViewCell else {
            fatalError("Could not dequeue a cell") }
        if eventData[0].itemBillOrEvent.count > 0 {
            cell.eventDescriptionLabel.text = eventData[0].itemBillOrEvent[indexPath.row]
            cell.timeLabel.text = eventData[0].priceAmountOrStartTime[indexPath.row]
        }  else {
            cell.eventDescriptionLabel.text = "No Appointments today"
            cell.timeLabel.text = ""
        }
        return cell
    }
}
