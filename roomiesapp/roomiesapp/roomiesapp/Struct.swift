//
//  Struct.swift
//  roomiesapp
//
//  Created by Gebruiker on 26-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation

struct overallData {
    var roommate = String()
    var what = [String]()
    var priceOrAmount = [String]()
    var keys = [String]()
    var withWho = [[String]]()
    var whoPutInList = [String]()
    
    mutating func removeAllData() {
        what.removeAll()
        priceOrAmount.removeAll()
        keys.removeAll()
        withWho.removeAll()
    }
    
    mutating func removeByName(name: String) {
        for (index, item) in whoPutInList.enumerated() {
            if item == name {
                what.remove(at: index)
                priceOrAmount.remove(at: index)
            }
        }
    }
    
    mutating func AddWhat(addWhat: String) {
        what.append(addWhat)
    }
    
    mutating func AddPrice(addPriceOrAmount: String) {
        priceOrAmount.append(addPriceOrAmount)
    }
    
    mutating func AddKeys(addKeys: String) {
        keys.append(addKeys)
    }
    
    mutating func AddWho(addWho: [String]) {
        withWho.append(addWho)
    }
    
    mutating func WhoAddedToList(who: String) {
        whoPutInList.append(who)
    }
}

struct friendRequest {
    var Name = String()
    var Accepted = Bool()
}

struct PendingRequest {
    var Name = String()
}

struct UsersOfApp {
    var potentialRoommate = String()
    var sendFriendRequest = Bool()
}

struct MyFriendRequestInfo {
    var pending = [String]()
    var request = [String]()
    var roommate = [String]()
    var keypending = [String]()
    var keyrequest = [String]()
    var keyroommate = [String]()
    
    mutating func addRoommate(name: String, key: String){
        roommate.append(name)
        keyroommate.append(key)
    }
    mutating func addPending(name: String, key: String){
        pending.append(name)
        keypending.append(key)
    }
    mutating func addRequest(name: String, key: String){
        request.append(name)
        keyrequest.append(key)
    }
    
    mutating func removeSomething(WhatToRemove: String) {
        if WhatToRemove == "pending" {
            pending.removeAll()
            keypending.removeAll()
        } else if WhatToRemove == "request" {
            request.removeAll()
            keyrequest.removeAll()
    
        } else {
            roommate.removeAll()
            keyroommate.removeAll()
        }
    }
}
