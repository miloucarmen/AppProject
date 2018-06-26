//
//  Settings.swift
//  roomiesapp
//
//  Created by Gebruiker on 19-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth





class Settings: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var settignsTableView: UITableView!
    
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle?
    var list: [String] = []
    var requests = [friendRequest]()
    var pendings = [PendingRequest]()
    var username = Login.UsersInfo.username
    
    var requestName: String = ""
    var pendingName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settignsTableView.delegate = self
        settignsTableView.dataSource = self
        username = Login.UsersInfo.username
        print("dit is de Username: .\(username).")
     
        ref = Database.database().reference()
        print(" \(username)")

        
        dataBaseHandle = ref.child(username).child("FriendRequests").observe(.value, with: { (snapshot) in
            self.requests.removeAll()
            if snapshot.childrenCount > 0 {
                print("Gaat nog goed")
                for request in snapshot.children.allObjects as! [DataSnapshot] {
                    let name = request.value as? String
                    if let nameIs = name {
                        self.requestName = nameIs
                    }
                }
                self.requests.append(friendRequest(Name: self.requestName, Accepted: false))
                print(self.requests)

            }
        })
        
        print("Nu hier")
        dataBaseHandle = ref?.child("\(username)").child("PendingFriendRequests").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {

                for request in snapshot.children.allObjects as! [DataSnapshot] {
                    let name = request.value as? String
                    if let nameIs = name {
                        self.pendings.append(PendingRequest(Name: nameIs))
                    }
                    
                }
            }
        })
        
        dataBaseHandle = ref?.child("Users").child(Login.UsersInfo.userID).child("huisgenoten").observe(.childAdded, with: { (snapshot) in
            let roomies = snapshot.value as? String
            if let roomiesName = roomies {
                Login.UsersInfo.roommates.append(roomiesName)
            }
        })
        print("Requests after loading", self.requests)
        print("Pending after loading", self.pendings)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return list.count // your number of cell here
        var rows = 0
        if section == 0 {
            rows = Login.UsersInfo.roommates.count
        }
        if section == 1 {
            print("How many requests",requests.count)
            rows = requests.count
        }
        if section == 2 {
            rows = pendings.count
        }
        return rows
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let blueIWant = UIColor(red:0.32, green:0.58, blue:0.59, alpha:1.0)
        view.backgroundColor = blueIWant
        
        let label = UILabel()
        
        if section == 0 {
            label.text = "Roommates"
            print("Roommates")
        }
        if section == 1 {
            label.text = "Roommate Requests"
            print("Requests")
        }
        if section == 2 {
            label.text = "Pending Requests"
            print("Pending")
        }
        
        label.frame = CGRect(x: 5, y: 5, width: 370, height: 35)
        view.addSubview(label)
        return view
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! SettingsCell
        if indexPath.section == 0 {
            cell.TitleCell.text = Login.UsersInfo.roommates[indexPath.row]
            cell.Button.setTitle("", for: .normal)
        } else if indexPath.section == 1 {
            cell.TitleCell.text = requests[indexPath.row].Name
            cell.Button.setTitle("+", for: .normal)
        } else {
            cell.TitleCell.text = pendings[indexPath.row].Name
            cell.Button.setTitle("", for: .normal)
        }

        return cell
    }
    
    @IBAction func unwindSettings(segue: UIStoryboardSegue) {
        
    }

}
