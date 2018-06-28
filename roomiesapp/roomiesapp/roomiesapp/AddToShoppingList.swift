//
//  AddToShoppingList.swift
//  roomiesapp
//
//  Created by Gebruiker on 27-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class AddToShoppingList: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var numberPicker: UIPickerView!
    @IBOutlet weak var amountLabel: UILabel!
    
    var shoppingList: overallData?
    var ref: DatabaseReference!
    let username = Login.UsersInfo.username

    func updateSaveButtonState() {
        saveButton.isEnabled = true
        if (itemTextField.text?.isEmpty)! || (amountLabel.text?.isEmpty)! {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func ReturnPressed(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func EditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
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
        amountLabel.text = "\(row)"
        updateSaveButtonState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if let shoppingList = shoppingList {
            itemTextField.text = shoppingList.itemBillOrEvent[0]
            amountLabel.text = shoppingList.priceAmountOrStartTime[0]
        }
        
        numberPicker.dataSource = self
        numberPicker.delegate = self
        
        updateSaveButtonState()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else {
            return
        }
        
        if let shoppingList = shoppingList {
            let Item = ["\(itemTextField.text!)": amountLabel.text ?? "1"]
            let updates = ["/\(shoppingList.whoPutInList)/shoppingList/\(shoppingList.keys[0])/": Item]
            ref.updateChildValues(updates)
            
        } else {
            self.ref?.child("\(username)").child("shoppingList").childByAutoId().updateChildValues(["\(itemTextField.text!)": amountLabel.text ?? "1"])
            print("Saved")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
