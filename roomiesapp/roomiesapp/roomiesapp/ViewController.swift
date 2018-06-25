//
//  ViewController.swift
//  roomiesapp
//
//  Created by Gebruiker on 06-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ViewController: UIViewController {

    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle?
    let userID = Login.UsersInfo.userID
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        dataBaseHandle = ref?.child("Users").child(userID).child("UserInfo").observe(.value, with: { (snapshot) in
            let userInformation = snapshot.value as! [String: Any]
            let username = userInformation["username"] as! String
            Login.UsersInfo.username.append(username)
//            print(Login.UsersInfo.username)
        })
        dataBaseHandle = ref?.child("Users").child(userID).child("huisgenoten").observe(.value, with: { (snapshot) in
            Login.UsersInfo.roommates.removeAll()
            Login.UsersInfo.roommates.append(Login.UsersInfo.username)
            for items in snapshot.children.allObjects as! [DataSnapshot] {
                let roommate = items.value as? String
                if let roommateIs = roommate {
                    Login.UsersInfo.roommates.append(roommateIs)
                }
            }
            print(Login.UsersInfo.roommates)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

