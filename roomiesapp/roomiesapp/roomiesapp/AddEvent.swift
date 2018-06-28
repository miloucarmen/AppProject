//
//  AddEvent.swift
//  roomiesapp
//
//  Creates new events for in the calendar and adds them
//

import Foundation
import UIKit
import FirebaseDatabase

class AddEvent: UITableViewController {
    
    // outlet created
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    // variable and constant
    let username = Login.UsersInfo.username
    var ref: DatabaseReference!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
        ref = Database.database().reference()
    }
    
    
    // updates save button when text changes
    @IBAction func TextChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    

    // checks for updated state save button
    func updateSaveButtonState() {
        saveButton.isEnabled = true
        if (eventTextField.text?.isEmpty)! {
            saveButton.isEnabled = false
        }
    }
    
    
    // prepers for unwind and if saveUnwind saves event in firebase
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else {
            return
        }
        
        let date = datePicker.date
        let time = timePicker.date
        
        // formates date and time label
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        timeFormatter.dateFormat = "HH:mm"
        
        // final date and time
        let selectedDate = dateFormatter.string(from: date)
        let selectedTime = timeFormatter.string(from: time)
        
        self.ref?.child("\(username)").child("Events").child(selectedDate).childByAutoId().updateChildValues([selectedTime: eventTextField.text ?? "15:00"])
        }
}
