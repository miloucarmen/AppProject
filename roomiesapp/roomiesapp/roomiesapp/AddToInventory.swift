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
    var numberArr = [Int]()
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
        return numberArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberArr[row])"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberLabel.text = "\(numberArr[row])"
        updateSaveButtonState()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if let inventory = inventory {
            itemTextField.text = inventory.what[0]
            numberLabel.text = inventory.priceOrAmount[0]
        }
        
        Number.dataSource = self
        Number.delegate = self
        
        for i in 0...100 {
            numberArr.append(i)
        }
        
        updateSaveButtonState()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else {
            return
        }
        
        if let inventory = inventory {
            let Item = ["\(itemTextField.text!)": numberLabel.text ?? "1"]
            let updates = ["/\(inventory.whoPutInList)/inventory/\(inventory.keys[0])/": Item]
            ref.updateChildValues(updates)
            
        } else {
            self.ref?.child("\(username)").child("inventory").childByAutoId().updateChildValues(["\(itemTextField.text!)": numberLabel.text ?? "1"])
            print("Saved")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}