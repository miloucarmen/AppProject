//
//  AddRoommate.swift
//  roomiesapp
//
//  Created by Gebruiker on 21-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase



class AddRoommate: UITableViewController {
    
    let sortOfFriends = ["PendingFriendRequests", "FriendRequests", "Roommate"]
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle?
    var username = Login.UsersInfo.username
    
    var relationToUser = [MyFriendRequestInfo]()
    var UsersApp = [UsersOfApp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        username = Login.UsersInfo.username
        
        dataBaseHandle = ref?.child("Users").observe(.childAdded, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                for userInfo in snapshot.children.allObjects as! [DataSnapshot]{
                    if userInfo.key == "UserInfo" {
                        let userInformation = userInfo.value as! [String: Any]
                        let usernameToAdd = userInformation["username"] as! String
                        if usernameToAdd != self.username {
                            self.UsersApp.append(UsersOfApp(potentialRoommate: usernameToAdd, sendFriendRequest: false))
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        })
        
        relationToUser.append(MyFriendRequestInfo(pending: [], request: [], roommate: [], keypending: [], keyrequest: [], keyroommate: []))
        
        for (_ ,name) in sortOfFriends.enumerated() {
            dataBaseHandle = ref?.child("\(username)").child("Roommates").child(name).observe(.value, with: { (snapshot) in
                if name == "PendingFriendRequests" {
                    self.relationToUser[0].removeSomething(WhatToRemove: "pending")
                } else if name == "FriendRequests" {
                    self.relationToUser[0].removeSomething(WhatToRemove: "request")
                } else {
                    self.relationToUser[0].removeSomething(WhatToRemove: "roommate")
                }
                
                if snapshot.childrenCount > 0 {
                    for Requests in snapshot.children.allObjects as! [DataSnapshot]{
                        if name == "PendingFriendRequests" {
                            self.relationToUser[0].addPending(name: Requests.value as! String, key: Requests.key)
                        } else if name == "FriendRequests" {
                            self.relationToUser[0].addRequest(name: Requests.value as! String, key: Requests.key)
                        } else {
                            self.relationToUser[0].addRoommate(name: Requests.value as! String, key: Requests.key)
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
        
    }
    
    
    // counts item in inentory and makes rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersApp.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as? AddRoommateCell else {
            fatalError("Could not dequeue a cell") }
        
        let name = UsersApp[indexPath.row].potentialRoommate
        cell.TitleText.text = name
        
        if relationToUser[indexPath.section].pending.contains(name) || relationToUser[indexPath.section].request.contains(name) || relationToUser[indexPath.section].roommate.contains(name) {
            UsersApp[indexPath.row].sendFriendRequest = true
            cell.Button.setTitle("V", for: .normal)
        } else {
            UsersApp[indexPath.row].sendFriendRequest = false
            cell.Button.setTitle("+", for: .normal)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let requestName = UsersApp[indexPath.row].potentialRoommate
        
        if UsersApp[indexPath.row].sendFriendRequest == false {
            UsersApp[indexPath.row].sendFriendRequest = true
            tableView.reloadRows(at: [indexPath], with: .none)

            let key = ref.child("\(username)").child("Roommates").child("PendingFriendRequests").childByAutoId().key
            
            self.ref?.child("\(username)").child("Roommates").child("PendingFriendRequests").child(key).setValue("\(requestName)")
            self.ref?.child(requestName).child("Roommates").child("FriendRequests").child(key).setValue("\(username)")
            
            
        } else {
            let index = relationToUser[0].pending.index(of: requestName)
        
            if let index = index {
                let key = relationToUser[0].keypending[index]
                self.ref?.child("\(username)").child("Roommates").child("PendingFriendRequests").child(key).setValue(nil)
                self.ref?.child("\(requestName)").child("Roommates").child("FriendRequests").child(key).setValue(nil)
            }
        }
    }
}
