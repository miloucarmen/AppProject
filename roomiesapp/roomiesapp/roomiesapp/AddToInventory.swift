//
//  AddToInventory.swift
//  roomiesapp
//
//  Created by Gebruiker on 07-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class AddToInventory: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var Number: UIPickerView!
    
    var inventory: overallData?
    var ref: DatabaseReference!
    let username = Login.UsersInfo.username

    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    
    @IBAction func returnIsPressed(_ sender: UITextField) {
        itemTextField.resignFirstResponder()
    }

    func updateSaveButtonState() {
        saveButton.isEnabled = true
        let text = itemTextField.text ?? ""
        let numb = numberLabel.text ?? ""
        if text.isEmpty || numb.isEmpty {
            saveButton.isEnabled = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberLabel.text = "\(row)"
        updateSaveButtonState()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if let inventory = inventory {
            itemTextField.text = inventory.itemBillOrEvent[0]
            numberLabel.text = inventory.priceAmountOrStartTime[0]
        }
        
        Number.dataSource = self
        Number.delegate = self
        
        updateSaveButtonState()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else {
            return
        }
        
        if let inventory = inventory {
            
            
            
            self.ref?.child("\(username)").child("inventory").child(inventory.keys[0]).updateChildValues(["\(itemTextField.text!)": numberLabel.text ?? "1"])
            
            
        } else {
            self.ref?.child("\(username)").child("inventory").childByAutoId().updateChildValues(["\(itemTextField.text!)": numberLabel.text ?? "1"])
            print("Saved")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
