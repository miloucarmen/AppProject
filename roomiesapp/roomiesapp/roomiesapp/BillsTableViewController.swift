//
//  BillsTableViewController.swift
//  roomiesapp
//
//  Created by Gebruiker on 19-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import UIKit
import FirebaseDatabase



struct OpenClose {
    var opened = Bool()
}


class BillsTableViewController: UITableViewController {

    // constants
    let username = Login.UsersInfo.username
    let roommates = Login.UsersInfo.roommates

    // variables created
    var data = [overallData]()
    var openClose = [OpenClose]()
    var i = 0
    var withWho = [[String]]()
    var loadTable = false
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle?
    

    // loads Bills in from firebase
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // gives every roommate a openClose handle
        for _ in roommates {
            openClose.append(OpenClose(opened: false))
        }
  
        // iterates over roommates
        for (index, name) in roommates.enumerated(){
            
            // finds Bill information
            dataBaseHandle = ref?.child("\(name)").child("Bills").observe(.value, with: { (snapshot) in
                
                // if roommate doesnt have data struct yet adds one
                if self.data.count < self.roommates.count {
                    self.data.append(overallData(roommateOrcurrentUser: name, itemBillOrEvent: [""], priceAmountOrStartTime: [""], keys: [""], withWho: [[]], whoPutInList: [""]))
                }
                
                // empties old information
                self.data[index].removeAllData()

                // if there is data on firebase extracts it
                if snapshot.childrenCount > 0 {
                    for itemskeys in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        self.data[index].AddKeys(addKeys: itemskeys.key)
                        for items in itemskeys.children.allObjects as! [DataSnapshot] {
                            
                            if items.key == "withWho" {
                                if let dataWithWho = items.value as? [String: String] {
                                    self.data[index].AddWho(addWho: Array(dataWithWho.values))
                                }
                            } else {
                                self.data[index].AddWhat(addWhat: items.key)
                                let amount = items.value as? String
                                
                                if let amountIs = amount {
                                    self.data[index].AddPrice(addPriceOrAmount: amountIs)
                                
                                }
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                self.tableView.reloadSectionIndexTitles()
            })
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return data.count
    }
    

    // deceides number of rows depending on whether table section is closed or opened
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !openClose[section].opened {
            return 0
        }
        return data[section].itemBillOrEvent.count
    }
    
    
    // makes row cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as? BillCell else {
            fatalError("Could not dequeue a cell") }
        cell.Item.text = self.data[indexPath.section].itemBillOrEvent[indexPath.row]
        cell.Costs.text = self.data[indexPath.section].priceAmountOrStartTime[indexPath.row]
        return cell
    }
   
    
    // makes custom header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // makes view and gives it a color
        let view = UIView()
        let blueIWant = UIColor(red:0.32, green:0.58, blue:0.59, alpha:1.0)
        view.backgroundColor = blueIWant
        
        // makes button and sets its settings
        let button = UIButton(type: .system)
        button.setTitle("\(data[section].roommateOrcurrentUser)", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 16, y: 5, width: 375, height: 35)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.tag = section
        button.addTarget(self, action: #selector(handelCloseOpen), for: .touchUpInside)
        
        
        // appends a label to header
        let label = UILabel()
        let labelName = WieBetaaltWat(section: section)
        if labelName < 0 {
            label.textColor = .red
        } else {
            label.textColor = .black
        }
        label.text = String(format: "%.2f", labelName)
        label.frame = CGRect(x: 300, y: 5, width: 75, height: 35)
        
        // adds label and button to view
        view.addSubview(button)
        view.addSubview(label)
        
        return view
    }
    
    
    // Calculates who gets what back
    func WieBetaaltWat (section: Int) -> Double {
        
        var voorgeschoten: Double = 0
        
        // iterates over all data of all roommates
        for (index, _) in data.enumerated() {
            
            // iterates over all bills payed by a roommate
            for (number, bill) in data[index].priceAmountOrStartTime.enumerated() {
                
                // calculation for what you have payed and what others have payed for you
                if index == section {
                    voorgeschoten += (((Double(bill)! * (Double(data[index].withWho[number].count - 1)) ) / Double(data[index].withWho[number].count)))
                } else {
                    if data[index].withWho[number].contains(data[section].roommateOrcurrentUser) {
                        print("Inside")
                        voorgeschoten -= (Double(bill)! / Double(data[index].withWho[number].count))
                    }
                }
            }
        }
        return voorgeschoten
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    // function for if button in header is pressed
    @objc func handelCloseOpen(button: UIButton) {
        
        // which header is the button located
        let section = button.tag
        var indexPaths = [IndexPath]()
        
        // adds all indexPaths of row that will be inserted or deleted
        for row in data[section].itemBillOrEvent.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        // changes status of openclose button
        let isOpened = openClose[section].opened
        openClose[section].opened = !isOpened
        
        // deletes rows or inserts
        if isOpened {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    
    // Only performs segue if you are the one that the Bill belongs to
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        // checks if its correct identifier
        if identifier == "showDetails" {
            
            // checks if you are "owner" of Bill
            let indexPath = tableView.indexPathForSelectedRow!
            if data[indexPath.section].roommateOrcurrentUser != username {
                return false
            }
        }
        return true
    }
    
    
    // prepares data to be send to AddToBill scene so it can be changed and updated
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            
            // constants
            let indexPath = tableView.indexPathForSelectedRow!
            let BillViewController = segue.destination as! AddToBills
            let selectedItem = data[indexPath.section]
            
            withWho.removeAll()
            withWho.append(data[indexPath.section].withWho[indexPath.row])
            
            let sendData = overallData(roommateOrcurrentUser: selectedItem.roommateOrcurrentUser, itemBillOrEvent: [selectedItem.itemBillOrEvent[indexPath.row]], priceAmountOrStartTime: [selectedItem.priceAmountOrStartTime[indexPath.row]], keys: [selectedItem.keys[indexPath.row]], withWho: withWho, whoPutInList: [""])
            
            // data that is forwarded
            BillViewController.Bill = sendData
        }
    }
    
    
    // creates possibility for unwinding to this page
    @IBAction func unwindBills(_ sender: UIStoryboardSegue){
  
    }
}
