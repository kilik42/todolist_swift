//
//  ToDoDetailTableViewController.swift
//  ToDoAppListProject
//
//  Created by marvin evins on 6/1/20.
//  Copyright © 2020 websavantmedia. All rights reserved.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {

   
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var nameField: UITextField!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var noteView: UITextView!
    
    var toDoItem: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.text = toDoItem
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = nameField.text
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
            
        }
    }
    
}
