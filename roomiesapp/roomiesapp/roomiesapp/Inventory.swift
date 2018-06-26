//
//  Inventory.swift
//  roomiesapp
//
//  Created by Gebruiker on 07-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Inventory: UITableViewController {
    
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle?
    let username = Login.UsersInfo.username
    let roommates = Login.UsersInfo.roommates
    var data = [overallData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        ref = Database.database().reference()
        
        self.data.append(overallData(roommate: username, what: [], priceOrAmount: [], keys: [], withWho: [[]], whoPutInList: []))
        
        for (_, name) in roommates.enumerated() {
            dataBaseHandle = ref?.child("\(name)").child("inventory").observe(.value, with: { (snapshot) in
                
                if self.data[0].whoPutInList.contains(name) {
                    self.data[0].removeByName(name: name)
                }
                
                if snapshot.childrenCount >= 0 {
                    
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
        return data[section].what.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
    indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddInventoryCellIdentifier") as? InventoryCel else {
            fatalError("Could not dequeue a cell") }
        
        cell.Item.text = data[indexPath.section].what[indexPath.row]
        cell.Amount.text = data[indexPath.section].priceOrAmount[indexPath.row]
        return cell

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt
    indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let item = data[indexPath.section].what[indexPath.row]
            let itemkey = data[indexPath.section].keys[indexPath.row]
            let addByWho = data[indexPath.section].whoPutInList[indexPath.row]
            ref?.child("\(addByWho)").child("inventory").child(itemkey).child(item).setValue(nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let inventoryViewController = segue.destination as! AddToInventory
            let indexPath = tableView.indexPathForSelectedRow!
            
            let selectedItem = data[indexPath.section]
            
            inventoryViewController.inventory = overallData(roommate: username, what: [selectedItem.what[indexPath.row]], priceOrAmount: [selectedItem.priceOrAmount[indexPath.row]], keys: [selectedItem.keys[indexPath.row]], withWho: [[]], whoPutInList: [selectedItem.whoPutInList[indexPath.row]])
        }
    }
    
    @IBAction func unwindInventoryList(segue: UIStoryboardSegue) {

    }
}

