//
//  ToDoDetailTableViewController.swift
//  ToDoAppListProject
//
//  Created by marvin evins on 6/1/20.
//  Copyright © 2020 websavantmedia. All rights reserved.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var nameField: UITextField!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var noteView: UITextView!
    
    var toDoItem: ToDoItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        if toDoItem == nil{
            toDoItem = ToDoItem(name: "", date: Date(), notes: "", reminderSet: false)
        }
        updateUserInterface()
       

    }
    
    func updateUserInterface(){
               nameField.text = toDoItem.name
               datePicker.date = toDoItem.date
               noteView.text = toDoItem.notes
               reminderSwitch.isOn = toDoItem.reminderSet
               dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn)
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    @IBAction func reminderSwitchChanged(_ sender: Any) {
          dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        
        //        if reminderSwitch.isOn {
        //            dateLabel.textColor = .black
        //        } else{
        //            dateLabel.textColor = .gray
        //        }
    }
    
}
