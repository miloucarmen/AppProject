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





class Settings: UIViewController, UITableViewDataSource, UITableViewDelegate, SettingsCellDelegate {
    
    
    
    @IBOutlet weak var settignsTableView: UITableView!
    
    
    let sortOfFriends = ["PendingFriendRequests", "FriendRequests", "Roommate"]
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle?
    var list: [String] = []
    var FriendInfo = [MyFriendRequestInfo]()
    var roundButton = UIButton()
    var username = Login.UsersInfo.username
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settignsTableView.allowsSelection = false
        settignsTableView.delegate = self
        settignsTableView.dataSource = self
        username = Login.UsersInfo.username
        
        print("dit is de Username: .\(username).")
     
        
        ref = Database.database().reference()
        FriendInfo.append(MyFriendRequestInfo(pending: [], request: [], roommate: [], keypending: [], keyrequest: [], keyroommate: []))
        
        for (_ ,name) in sortOfFriends.enumerated() {
            dataBaseHandle = ref?.child("\(username)").child("Roommates").child(name).observe(.value, with: { (snapshot) in
                if name == "PendingFriendRequests" {
                    self.FriendInfo[0].removeSomething(WhatToRemove: "pending")
                } else if name == "FriendRequests" {
                    self.FriendInfo[0].removeSomething(WhatToRemove: "request")
                } else {
                    self.FriendInfo[0].removeSomething(WhatToRemove: "roommate")
                }
                
                if snapshot.childrenCount > 0 {
                    for Requests in snapshot.children.allObjects as! [DataSnapshot]{
                        if name == "PendingFriendRequests" {
                            self.FriendInfo[0].addPending(name: Requests.value as! String, key: Requests.key)
                        } else if name == "FriendRequests" {
                            self.FriendInfo[0].addRequest(name: Requests.value as! String, key: Requests.key)
                        } else {
                            self.FriendInfo[0].addRoommate(name: Requests.value as! String, key: Requests.key)
                        }
                    }
                }
                self.settignsTableView.reloadData()
            })
        }
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.blue, for: .normal)
        self.roundButton.addTarget(self, action: #selector(AddNewRoommate(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(roundButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return FriendInfo[0].roommate.count
        } else if section == 1 {
            return FriendInfo[0].request.count
        } else {
            return FriendInfo[0].pending.count
        }
        
        
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
        cell.delegate = self
        if indexPath.section == 0 {
            cell.TitleCell.text = FriendInfo[0].roommate[indexPath.row]
            cell.Button.setTitle("", for: .normal)
        } else if indexPath.section == 1 {
            cell.TitleCell.text = FriendInfo[0].request[indexPath.row]
            cell.Button.setTitle("+", for: .normal)
            cell.Button.setTitleColor(.blue, for: .normal)
        } else {
            cell.TitleCell.text = FriendInfo[0].pending[indexPath.row]
            cell.Button.setTitle("-", for: .normal)
            cell.Button.setTitleColor(.blue, for: .normal)
        }

        return cell
    }
    
    override func viewWillLayoutSubviews() {
        
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.white
        roundButton.clipsToBounds = true
        roundButton.setTitle("+", for: .normal)
        roundButton.setTitleColor(.blue, for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
            roundButton.widthAnchor.constraint(equalToConstant: 50),
            roundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    @IBAction func AddNewRoommate(_ sender: UIButton){
        
        self.performSegue(withIdentifier: "AddRoommate", sender: nil)
        
    }
    
    func didPressButton(sender: SettingsCell) {
        if let indexPath = settignsTableView.indexPath(for: sender) {
            
            if indexPath.section == 1 {
                let requestName = FriendInfo[0].request[indexPath.row]
                let key = FriendInfo[0].keyrequest[indexPath.row]
                let newKey = ref.child("\(username)").child("Roommates").child("Roommate").childByAutoId().key
                
                let updates = ["/\(requestName)/Roommates/PendingFriendRequests/\(key)/": NSNull(),
                               "/\(username)/Roommates/FriendRequests/\(key)/": NSNull(),
                               "/\(username)/Roommates/Roommate/\(newKey)/": "\(requestName)",
                    "/\(requestName)/Roommates/Roommate/\(newKey)/": "\(username)"] as [String : Any]
                
                ref.updateChildValues(updates)
                Login.UsersInfo.roommates.append("\(requestName)")
                
                
            }
            if indexPath.section == 2 {
                let requestName = FriendInfo[0].pending[indexPath.row]
                let key = FriendInfo[0].keypending[indexPath.row]

                let updates = ["/\(username)/Roommates/PendingFriendRequests/\(key)/": NSNull(),
                               "/\(requestName)/Roommates/FriendRequests/\(key)/": NSNull()]
                
                ref.updateChildValues(updates)
                
            }
        }
    }
    
    
    @IBAction func unwindSettings(segue: UIStoryboardSegue) {
        
    }

}
