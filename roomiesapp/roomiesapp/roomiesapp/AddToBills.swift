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

    
    @IBOutlet weak var tableInTable: UITableView!
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pricePicker: UIPickerView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    

    
    var Bill: overallData?
    var ref: DatabaseReference!
    var NumberArr: [Int] = []
    var j = 0
    let username = Login.UsersInfo.username
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if let Bill = Bill {
            DescriptionTextField.text = Bill.what[0]
            priceLabel.text = Bill.priceOrAmount[0]
        }
        
        pricePicker.dataSource = self
        pricePicker.delegate = self
        let controller = Innertablecontroler()
        tableInTable.dataSource = controller
        tableInTable.delegate = controller
        
        while j <= 100{
            NumberArr.append(j)
            j += 1
        }
        
        
        updateSaveButtonState()
        
    }
    
    
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            let height = CGFloat(Login.UsersInfo.roommates.count * 70)
            return height
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwindBills" else {
            return
        }

        print("Trying to save......")
        
        if let Bill = Bill {

            let ItemPrice = ["\(DescriptionTextField.text!)": priceLabel.text!,
                             "withWho": ["roommate1": "miloucarmen", "roommate2": "lol"]] as [String : Any]
           
            
            let updates = ["/\(username)/Bills/\(Bill.keys[0])/": ItemPrice]
            ref.updateChildValues(updates)
            
            print("updated")
        } else {
            
            let key = ref.child("\(username)").child("Bills").childByAutoId().key
            let ItemPrice = ["\(DescriptionTextField.text!)": priceLabel.text!,
                             "withWho": ["roommate1": "miloucarmen", "roommate2": "lol"]] as [String : Any]
            
            let updates = ["/\(username)/Bills/\(key)/": ItemPrice]
            
            ref.updateChildValues(updates)

            print("saved")}
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class Innertablecontroler: NSObject, UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("HIERR: ",Login.UsersInfo.roommates.count)
        return (Login.UsersInfo.roommates.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InsideTable") as? InsideTableCell else {
            fatalError("Could not dequeue a cell") }
        cell.TitleCell.text = "\(Login.UsersInfo.roommates[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

}


