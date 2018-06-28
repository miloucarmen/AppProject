//
//  AddEvent.swift
//  roomiesapp
//
//  Created by Gebruiker on 28-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class AddEvent: UITableViewController {
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    let username = Login.UsersInfo.username
    var ref: DatabaseReference!
   
    
    @IBAction func TextChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
        ref = Database.database().reference()
    }
    
    func updateSaveButtonState() {
        saveButton.isEnabled = true
        if (eventTextField.text?.isEmpty)! {
            saveButton.isEnabled = false
        }
    }
    
    func date() {
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else {
            return
        }
        
        let date = datePicker.date
        let time = timePicker.date
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        timeFormatter.dateFormat = "HH:mm"
        
        
        let selectedDate = dateFormatter.string(from: date)
        let selectedTime = timeFormatter.string(from: time)
        
        self.ref?.child("\(username)").child("Events").child(selectedDate).childByAutoId().updateChildValues([selectedTime: eventTextField.text ?? "15:00"])
        
        }
}
