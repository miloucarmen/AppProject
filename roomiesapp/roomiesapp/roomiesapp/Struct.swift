

import Foundation

// struct used in Bill, Inventory and shoppingList part of app
struct overallData {
    var roommateOrcurrentUser = String()
    var itemBillOrEvent = [String]()
    var priceAmountOrStartTime = [String]()
    var keys = [String]()
    var withWho = [[String]]()
    var whoPutInList = [String]()
    
    mutating func removeAllData() {
        itemBillOrEvent.removeAll()
        priceAmountOrStartTime.removeAll()
        keys.removeAll()
        withWho.removeAll()
    }
    
    // removes all data put in list by a certain roommate
    mutating func removeByName(name: String) {
        let totalItems = whoPutInList.count - 1
        
        // goes through list in reversed order deletes last first so index doesn't go out of range
        for (index, item) in whoPutInList.reversed().enumerated() {
            if item == name {
                let valueToRemove = totalItems - index
                itemBillOrEvent.remove(at: valueToRemove)
                priceAmountOrStartTime.remove(at: valueToRemove)
                whoPutInList.remove(at: valueToRemove)
                keys.remove(at: valueToRemove)
            }
        }
    }
    
    mutating func AddSorted(addTime: String, addEvent: String, addWho: String, addKey: String){
        priceAmountOrStartTime.append(addTime)
        priceAmountOrStartTime.sort()
        
        if let index = priceAmountOrStartTime.index(of: addTime) {
            itemBillOrEvent.insert(addEvent, at: index)
            keys.insert(addKey, at: index)
            whoPutInList.insert(addWho, at: index)
        }
    }
    
    // appending fucntions
    mutating func AddWhat(addWhat: String) {
        itemBillOrEvent.append(addWhat)
    }
    
    mutating func AddPrice(addPriceOrAmount: String) {
        priceAmountOrStartTime.append(addPriceOrAmount)
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

// structures used in settings part of app
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
