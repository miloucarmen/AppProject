//
//  AddToBills.swift
//  roomiesapp
//
//  Created by Gebruiker on 21-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase



class AddToBills: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pricePicker: UIPickerView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    
    var Bill: billData?
    var ref: DatabaseReference!
    var NumberArr: [Int] = []
    var j = 0
    let username = Login.UsersInfo.username
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func TextEditing(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func returnIsPressed(_ sender: UITextField) {
        DescriptionTextField.resignFirstResponder()
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        saveButton.isEnabled = true

        if (DescriptionTextField.text?.isEmpty)! ||  (priceLabel.text?.isEmpty)! {
            saveButton.isEnabled = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return (NumberArr.count)
        } else if component == 1{
            return 1
        } else {
            return 10
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(NumberArr[row])"
        } else if component == 1 {
            return ","
        } else {
            return "\(NumberArr[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedEuro = pricePicker.selectedRow(inComponent: 0)
        let selectedCent = pricePicker.selectedRow(inComponent: 2)
        let selectedCents = pricePicker.selectedRow(inComponent: 3)
        let euro = NumberArr[selectedEuro ]
        let cent = NumberArr[selectedCent]
        let cents = NumberArr[selectedCents]
        priceLabel.text = "\(euro).\(cent)\(cents)"
        updateSaveButtonState()
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        if let Bill = Bill {
            DescriptionTextField.text = Bill.what[0]
            priceLabel.text = Bill.price[0]
        }

        pricePicker.dataSource = self
        pricePicker.delegate = self
        
        
        while j <= 100{
            NumberArr.append(j)
            j += 1
        }
        
        
        updateSaveButtonState()
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwindBills" else {
            return
        }

        print("Trying to save......")
        
        if let Bill = Bill {
            self.ref = self.ref?.child("\(username)").child("Bills").child(Bill.keys[0])
            
            self.ref?.updateChildValues(["\(DescriptionTextField.text!)": priceLabel.text!])
            self.ref = self.ref?.child("withWho")
            let bill = ["roommate1": "miloucarmen", "roommate2": "lol"]
            self.ref?.setValue(bill)
            
            print("updated")
        } else {
            self.ref = self.ref?.child("\(username)").child("Bills").childByAutoId()
            
            
            self.ref?.updateChildValues(["\(DescriptionTextField.text!)": priceLabel.text!])
            self.ref = self.ref?.child("withWho")
            let bill = ["roommate1": "miloucarmen", "roommate2": "lol"]
            self.ref?.setValue(bill)
            print("saved")}
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension UITableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
 
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IDLabelCell", for: indexPath) as! BillCollectionView
        return cell
    }
    
    
}
