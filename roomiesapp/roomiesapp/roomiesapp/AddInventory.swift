//
//  AddInventory.swift
//  roomiesapp
//
//  Created by Gebruiker on 08-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation

struct AddInventory: Codable {
    var whatToAdd: String
    var amount: String
    
    static func loadInventory() -> [AddInventory]?  {
        guard let codedInventory = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<AddInventory>.self, from: codedInventory)
    }

    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("inventory").appendingPathExtension("plist")
    
    
    static func saveInventory(_ inventory: [AddInventory]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedInventory = try? propertyListEncoder.encode(inventory)
        try? codedInventory?.write(to: ArchiveURL, options: .noFileProtection)
    }

}
