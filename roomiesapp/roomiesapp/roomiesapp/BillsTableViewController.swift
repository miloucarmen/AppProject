//
//  BillsTableViewController.swift
//  roomiesapp
//
//  Created by Gebruiker on 19-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct billData {
    var roommate = String()
    var what = [String]()
    var price = [String]()
    var keys = [String]()
    var withWho = [[String]]()
}

struct OpenClose {
    var opened = Bool()
}


class BillsTableViewController: UITableViewController {
 
    
    
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle?
    let username = Login.UsersInfo.username
    let roommates = Login.UsersInfo.roommates
    
    
    // load in from firebase
    var data = [billData]()
    var item: [String] = []
    var keys: [String] = []
    var costs: [String] = []
    var withWho = [[String]]()
    var openClose = [OpenClose]()
    var i = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        for _ in roommates {
            openClose.append(OpenClose(opened: false))
            print(openClose)
        }
        
        for name in roommates {
            print(name)
            
            dataBaseHandle = ref?.child("\(name)").child("Bills").observe(.value, with: { (snapshot) in
                print("IN HANDELLLL NOW FOR: ",name)
                
                // checks if data was already filled or not
                
                
                if self.data.count < self.roommates.count {
                    while name != self.roommates[self.i] {
                        self.i += 1
                    }
                } else {
                    while name != self.data[self.i].roommate{
                        self.i += 1
                    }
                }
                
                
                if self.data.count > self.i {
                    print("This data Will be removed")
                    self.data.remove(at: self.i)
                    
                }
                
                self.keys.removeAll()
                self.item.removeAll()
                self.costs.removeAll()
                self.withWho.removeAll()
                
                if snapshot.childrenCount >= 0 {
                    for itemskeys in snapshot.children.allObjects as! [DataSnapshot] {
//                        print(itemskeys)
                        self.keys.append(itemskeys.key)
                        for items in itemskeys.children.allObjects as! [DataSnapshot] {
                            
                            if items.key == "withWho" {
                                if let dataWithWho = items.value as? [String: String] {
                                    self.withWho.append(Array(dataWithWho.values))
                                    print("With who will it be shared",self.withWho)
                                }
                            } else {
                                self.item.append("\(items.key)")
                                let amount = items.value as? String
                                
                                if let amountIs = amount {
                                    self.costs.append(amountIs)
//                                    print(self.costs)
                                
                                }
                            }
                        }
                    }
                    self.data.append(billData(roommate: name, what: self.item, price: self.costs, keys: self.keys, withWho: self.withWho))
                    print("")
                    print("EVERYTHING IS HERE",self.data)
                    print("")
                    self.tableView.reloadData()
                    self.tableView.reloadSectionIndexTitles()
                }
                self.i = 0

                
            })
    
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !openClose[section].opened {
            return 0
        }
        return data[section].what.count
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as? BillCell else {
            fatalError("Could not dequeue a cell") }
        cell.Item.text = self.data[indexPath.section].what[indexPath.row]
        cell.Costs.text = self.data[indexPath.section].price[indexPath.row]
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
        print("alll data", data[section])
//        print("header for section",section)
//        print("which roommate are we looking at", section)
//
//        print("\(0...data.count)")
//
        for j in 0...(data.count - 1) {
            print("How many people",data.count)
            var i = 0
//            print("person info",j)
//
            for bill in data[j].price {
//
                if j == section {
                    voorgeschoten += (Double(bill)! / Double(data[j].withWho[i].count))
                }
                if j != section && data[j].withWho[i].contains(username){
                    voorgeschoten -= (Double(bill)! / Double(data[j].withWho[i].count))
                }
                i += 1
            }
        }
        i = 0
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
            let sendData = billData(roommate: selectedItem.roommate, what: [selectedItem.what[indexPath.row]], price: [selectedItem.price[indexPath.row]], keys: [selectedItem.keys[indexPath.row]], withWho: withWho)
            print("Data die wordt gestuurd", sendData)
            
            BillViewController.Bill = sendData
        }
//        if segue.identifier == "Cancel" {
//
//        }
    }
    
    
    
    @IBAction func unwindBills(_ sender: UIStoryboardSegue){
    
        
        
    }
}
