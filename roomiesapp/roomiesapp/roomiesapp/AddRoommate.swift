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

struct UsersOfApp {
    var potentialRoommate = String()
    var sendFriendRequest = Bool()
}

class AddRoommate: UITableViewController {
    
    var ref: DatabaseReference!
    var inventoryList = [AddInventory]()
    var dataBaseHandle: DatabaseHandle?
    let username = Login.UsersInfo.username
    
    var UsersApp = [UsersOfApp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
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
    }
    
    
    // counts item in inentory and makes rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersApp.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as? AddRoommateCell else {
            fatalError("Could not dequeue a cell") }
        cell.TitleText.text = UsersApp[indexPath.row].potentialRoommate
        if UsersApp[indexPath.row].sendFriendRequest == false {
            cell.Button.setTitle("+", for: .normal)
        } else {
            cell.Button.setTitle("V", for: .normal)
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("its working")
        if UsersApp[indexPath.row].sendFriendRequest == false {
            UsersApp[indexPath.row].sendFriendRequest = true
            tableView.reloadRows(at: [indexPath], with: .none)
            self.ref?.child("\(username)").child("PendingFriendRequests").childByAutoId().setValue("\(UsersApp[indexPath.row].potentialRoommate)")
            self.ref?.child("\(UsersApp[indexPath.row].potentialRoommate)").child("FriendRequests").childByAutoId().setValue("\(username)")

        }
    }
}
