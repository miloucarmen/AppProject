import Foundation
import UIKit
import FirebaseDatabase

class ShoppingList: UITableViewController, ShoppingListCellDelegate {
    
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle?
    let username = Login.UsersInfo.username
    let roommates = Login.UsersInfo.roommates
    var data = [overallData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        self.data.append(overallData(roommateOrcurrentUser: username, itemBillOrEvent: [], priceAmountOrStartTime: [], keys: [], withWho: [[]], whoPutInList: []))
        
        for (_, name) in roommates.enumerated() {
            dataBaseHandle = ref?.child("\(name)").child("shoppingList").observe(.value, with: { (snapshot) in
                print("data", self.data[0])
                if self.data[0].whoPutInList.contains(name) {
                    self.data[0].removeByName(name: name)
                }
                
                if snapshot.childrenCount > 0 {
                    
                    for items in snapshot.children.allObjects as! [DataSnapshot] {
                        self.data[0].AddKeys(addKeys: items.key)
                        for item in items.children.allObjects as! [DataSnapshot] {
                            self.data[0].AddWhat(addWhat: item.key)
                            self.data[0].WhoAddedToList(who: name)
                            let amount = item.value as? String
                            
                            if let amountIs = amount {
                                self.data[0].AddPrice(addPriceOrAmount: amountIs)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
    }
    
    
    // counts item in inentory and makes rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].itemBillOrEvent.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCellIdentifier") as? ShoppingListCell else {
            fatalError("Could not dequeue a cell") }
        
        cell.titleLabel.text = data[indexPath.section].itemBillOrEvent[indexPath.row]
        cell.amountLabel.text = data[indexPath.section].priceAmountOrStartTime[indexPath.row]
        cell.delegate = self
        
        return cell
        
    }
    
    func didPressButton(sender: ShoppingListCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            tableView(tableView, commit: .delete, forRowAt: indexPath)
            self.ref?.child("\(username)").child("inventory").childByAutoId().updateChildValues(["\(sender.titleLabel.text!)": sender.amountLabel.text ?? "1"])
        }
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = data[indexPath.section].itemBillOrEvent[indexPath.row]
            let itemkey = data[indexPath.section].keys[indexPath.row]
            let addByWho = data[indexPath.section].whoPutInList[indexPath.row]
            ref?.child("\(addByWho)").child("shoppingList").child(itemkey).child(item).setValue(nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let inventoryViewController = segue.destination as! AddToInventory
            let indexPath = tableView.indexPathForSelectedRow!
            
            let selectedItem = data[indexPath.section]
            
            inventoryViewController.inventory = overallData(roommateOrcurrentUser: username, itemBillOrEvent: [selectedItem.itemBillOrEvent[indexPath.row]], priceAmountOrStartTime: [selectedItem.priceAmountOrStartTime[indexPath.row]], keys: [selectedItem.keys[indexPath.row]], withWho: [[]], whoPutInList: [selectedItem.whoPutInList[indexPath.row]])
        }
    }
    
    @IBAction func unwindShoppingList(segue: UIStoryboardSegue) {
        
    }
}


