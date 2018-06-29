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



var withWho = [String]()

class AddToBills: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var tableInTable: UITableView!
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pricePicker: UIPickerView!
    

    
    let username = Login.UsersInfo.username
    var Bill: overallData?
    var ref: DatabaseReference!
    var controller: Innertablecontroler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if let Bill = Bill {
            DescriptionTextField.text = Bill.itemBillOrEvent[0]
            priceLabel.text = Bill.priceAmountOrStartTime[0]
            for name in Bill.withWho[0]{
                withWho.append(name)
            }
        } else {
            withWho = Login.UsersInfo.roommates
        }
        
        pricePicker.dataSource = self
        pricePicker.delegate = self
        
        controller = Innertablecontroler()
        tableInTable.dataSource = controller
        tableInTable.delegate = controller
        tableInTable.tableFooterView = UIView()
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
            return 100
        } else if component == 1{
            return 1
        } else {
            return 10
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row)"
        } else if component == 1 {
            return ","
        } else {
            return "\(row)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedEuro = pricePicker.selectedRow(inComponent: 0)
        let selectedCent = pricePicker.selectedRow(inComponent: 2)
        let selectedCents = pricePicker.selectedRow(inComponent: 3)

        priceLabel.text = "\(selectedEuro).\(selectedCent)\(selectedCents)"
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
            withWho.removeAll()
            return
        }
        
        var personData: [String: String] = [:]
        for (index, name) in withWho.enumerated() {
            personData["roommate\(index)"] = name
        }
        
        let ItemPrice = ["\(DescriptionTextField.text!)": priceLabel.text!,
                         "withWho": personData] as [String : Any]
        
        if let Bill = Bill {
            let updates = ["/\(username)/Bills/\(Bill.keys[0])/": ItemPrice]
            ref.updateChildValues(updates)
            withWho.removeAll()
        } else {
            
            let key = ref.child("\(username)").child("Bills").childByAutoId().key
            let updates = ["/\(username)/Bills/\(key)/": ItemPrice]
            ref.updateChildValues(updates)
            withWho.removeAll()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}





class Innertablecontroler: NSObject, UITableViewDelegate, UITableViewDataSource, InsideTableCellDelegate  {
    
    func SwitchEnabled(sender: InsideTableCell) {

        let row = sender.SwitchButton.tag
        if sender.SwitchButton.isOn {
            withWho.append(Login.UsersInfo.roommates[row])
        } else {
            if let index = withWho.index(of: Login.UsersInfo.roommates[row]) {
                withWho.remove(at: index)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Login.UsersInfo.roommates.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InsideTable") as? InsideTableCell else {
            fatalError("Could not dequeue a cell") }
        cell.delegate = self
        cell.SwitchButton.tag = indexPath.row
        cell.TitleCell.text = "\(Login.UsersInfo.roommates[indexPath.row])"
        if withWho.index(of: "\(Login.UsersInfo.roommates[indexPath.row])") == nil {
            cell.SwitchButton.isOn = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

}


