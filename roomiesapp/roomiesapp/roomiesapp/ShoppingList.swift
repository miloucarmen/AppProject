//
// ShoppingList class
// Its a table view that extracts the grocery lists from all roommates from firebase
//
//
//

import Foundation
import UIKit
import FirebaseDatabase

class ShoppingList: UITableViewController, ShoppingListCellDelegate {
    
    // variables and constants created
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle?
    var data = [overallData]()
    let username = Login.UsersInfo.username
    let roommates = Login.UsersInfo.roommates
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        // data structure appened to store all grocerylists
        self.data.append(overallData(roommateOrcurrentUser: username, itemBillOrEvent: [], priceAmountOrStartTime: [], keys: [], withWho: [[]], whoPutInList: []))
        
        // iterates over all roommates
        for (_, name) in roommates.enumerated() {
            
            // finds location of roommates grocerylist
            dataBaseHandle = ref?.child("\(name)").child("shoppingList").observe(.value, with: { (snapshot) in
                
                // removes old data from a roommate
                if self.data[0].whoPutInList.contains(name) {
                    self.data[0].removeByName(name: name)
                }
                
                // if there is data in list extracts it
                if snapshot.childrenCount > 0 {
                    
                    // iterates over autoIDKeys
                    for items in snapshot.children.allObjects as! [DataSnapshot] {
                        self.data[0].AddKeys(addKeys: items.key)
                        
                        // Grocery items
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
    
    
    // creates cell according to custom cell: ShoppingListCell
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCellIdentifier") as? ShoppingListCell else {
            fatalError("Could not dequeue a cell") }
        

        cell.titleLabel.text = data[indexPath.section].itemBillOrEvent[indexPath.row]
        cell.amountLabel.text = data[indexPath.section].priceAmountOrStartTime[indexPath.row]
        cell.delegate = self
        
        return cell
        
    }
    
    
    // excecutes protocol when button is pressed
    func didPressButton(sender: ShoppingListCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            
            // deletes row
            tableView(tableView, commit: .delete, forRowAt: indexPath)
            
            // adds item to inventory
            self.ref?.child("\(username)").child("inventory").childByAutoId().updateChildValues(["\(sender.titleLabel.text!)": sender.amountLabel.text ?? "1"])
        }
    }

    
    // removes item from shoppingList
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = data[indexPath.section].itemBillOrEvent[indexPath.row]
            let itemkey = data[indexPath.section].keys[indexPath.row]
            let addByWho = data[indexPath.section].whoPutInList[indexPath.row]
            ref?.child("\(addByWho)").child("shoppingList").child(itemkey).child(item).setValue(nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    // prepares showDetails segue information is passed to AddToShoppingList for editing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showDetails" {

            let shoppingListViewController = segue.destination as! AddToShoppingList
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedItem = data[indexPath.section]
            print(selectedItem)
            // passes selected item to shoppingList
            shoppingListViewController.shoppingList = overallData(roommateOrcurrentUser: username, itemBillOrEvent: [selectedItem.itemBillOrEvent[indexPath.row]], priceAmountOrStartTime: [selectedItem.priceAmountOrStartTime[indexPath.row]], keys: [selectedItem.keys[indexPath.row]], withWho: [[]], whoPutInList: [selectedItem.whoPutInList[indexPath.row]])
        }
    }
    
    
    @IBAction func unwindShoppingList(segue: UIStoryboardSegue) {
        
    }
}


