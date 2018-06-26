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
 
    
    
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle?
    let username = Login.UsersInfo.username
    let roommates = Login.UsersInfo.roommates
    
    
    // load in from firebase
    var data = [overallData]()
    var openClose = [OpenClose]()
    var i = 0
    var withWho = [[String]]()
    var loadTable = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        for _ in roommates {
            openClose.append(OpenClose(opened: false))
            print(openClose)
        }
  
        for (index, name) in roommates.enumerated(){
            print("\(name)")
            
            dataBaseHandle = ref?.child("\(name)").child("Bills").observe(.value, with: { (snapshot) in
                print("IN HANDELLLL NOW FOR: ",name)
                
                if self.data.count < self.roommates.count {
                    self.data.append(overallData(roommate: name, what: [""], priceOrAmount: [""], keys: [""], withWho: [[]], whoPutInList: [""]))
                    print("Data die net alleen met naam gevuld is",self.data)

                }

                self.data[index].removeAllData()

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
                print("")
                print("EVERYTHING IS HERE",self.data)
                print("")
                self.tableView.reloadData()
                self.tableView.reloadSectionIndexTitles()
            })
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("Data Count is",data.count)
        return data.count
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !openClose[section].opened {
            return 0
        }
        print("Section \(section) has \(data[section].what.count) rows")
        return data[section].what.count
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as? BillCell else {
            fatalError("Could not dequeue a cell") }
        cell.Item.text = self.data[indexPath.section].what[indexPath.row]
        cell.Costs.text = self.data[indexPath.section].priceOrAmount[indexPath.row]
        return cell
    
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        let blueIWant = UIColor(red:0.32, green:0.58, blue:0.59, alpha:1.0)
        view.backgroundColor = blueIWant
        
        
        
        let button = UIButton(type: .system)
        button.setTitle("\(data[section].roommate)", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 16, y: 5, width: 375, height: 35)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.tag = section
        button.addTarget(self, action: #selector(handelCloseOpen), for: .touchUpInside)
        
        
        
        
        let label = UILabel()
        let labelName = WieBetaaltWat(section: section)
        label.text = "\(labelName)"
        label.frame = CGRect(x: 320, y: 5, width: 55, height: 35)
        
        view.addSubview(button)
        view.addSubview(label)
        
        return view
    }
    
    func WieBetaaltWat (section: Int) -> Double {
        
        var voorgeschoten: Double = 0
//        print("header for section",section)
//        print("which roommate are we looking at", section)
//
//        print("\(0...data.count)")
//
        for (index, _) in data.enumerated() {
            var itemInList = 0
//            print("person info",j)
//
            for bill in data[index].priceOrAmount {

                if index == section {
                    voorgeschoten += (Double(bill)! / Double(data[index].withWho[itemInList].count))
                }
                if index != section && data[index].withWho[itemInList].contains(username){
                    voorgeschoten -= (Double(bill)! / Double(data[index].withWho[itemInList].count))
                }
                itemInList += 1
            }
        }
        return voorgeschoten
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    @objc func handelCloseOpen(button: UIButton) {
        
        // which header is the button located
        let section = button.tag
        var indexPaths = [IndexPath]()
        
        for row in data[section].what.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isOpened = openClose[section].opened
        openClose[section].opened = !isOpened
        
        if isOpened {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showDetails" {
            
            print("Hier")
            let indexPath = tableView.indexPathForSelectedRow!
            if data[indexPath.section].roommate != username {
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let indexPath = tableView.indexPathForSelectedRow!
            let BillViewController = segue.destination as! AddToBills
            
            let selectedItem = data[indexPath.section]
            withWho.removeAll()
            withWho.append(data[indexPath.section].withWho[indexPath.row])
            print(withWho)
            print(selectedItem.roommate)
            let sendData = overallData(roommate: selectedItem.roommate, what: [selectedItem.what[indexPath.row]], priceOrAmount: [selectedItem.priceOrAmount[indexPath.row]], keys: [selectedItem.keys[indexPath.row]], withWho: withWho, whoPutInList: [""])
            print("Data die wordt gestuurd", sendData)
            
            BillViewController.Bill = sendData
        }
    }
    
    
    
    @IBAction func unwindBills(_ sender: UIStoryboardSegue){
  
    }
}
