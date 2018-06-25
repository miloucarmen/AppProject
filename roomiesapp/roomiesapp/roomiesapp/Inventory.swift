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
    var inventoryList = [AddInventory]()
    var dataBaseHandle: DatabaseHandle?
    let username = Login.UsersInfo.username
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        ref = Database.database().reference()
        
        dataBaseHandle = ref?.child("Users").child("\(username)").child("inventory").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount >= 0 {
                self.inventoryList.removeAll()
                
                for items in snapshot.children.allObjects as! [DataSnapshot] {
                    let item = "\(items.key)"
                    let amount = items.value as? String
                    
                    if let amountIs = amount {
                        let newItem = AddInventory(whatToAdd: item, amount: amountIs)
                        self.inventoryList.append(newItem)
//                        self.tableView.reloadData()
                    }
                }
            }
        })
    }

    // counts item in inentory and makes rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
    indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddInventoryCellIdentifier") as? InventoryCel else {
            fatalError("Could not dequeue a cell") }
        cell.Item.text = inventoryList[indexPath.row].whatToAdd
        cell.Amount.text = inventoryList[indexPath.row].amount
        return cell

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt
    indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            print("\(indexPath.row)")
            
            let item = inventoryList[indexPath.row].whatToAdd
            ref?.child("Users").child("\(username)").child("inventory").child(item).setValue(nil)
            
            inventoryList.remove(at: indexPath.row)
            AddInventory.saveInventory(inventoryList)
            
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let inventoryViewController = segue.destination as! AddToInventory
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedItem = inventoryList[indexPath.row]
            inventoryViewController.inventory = selectedItem
        }
    }
    
    @IBAction func unwindInventoryList(segue: UIStoryboardSegue) {

    }
}

