//
//  ViewController.swift
//  ToDoAppListProject
//
//  Created by marvin evins on 6/1/20.
//  Copyright © 2020 websavantmedia. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var tableview: UITableView!
    
    var toDoArray = ["learn swift","learn blockchain","learn ml","buidl portfolio","learn mobile development"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
        
        
        
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numbers of rows in section was just called \(toDoArray.count)")
        return toDoArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        
        return cell
       }
    
    //send data to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = tableview.indexPathForSelectedRow!
            destination.toDoItem = toDoArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableview.indexPathForSelectedRow{
                tableview.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }

    @IBAction func unwindFromDetail(segue: UIStoryboardSegue){
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = tableview.indexPathForSelectedRow{
            toDoArray[selectedIndexPath.row] = source.toDoItem
            tableview.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else{
            let newIndexPath = IndexPath(row: toDoArray.count, section:0)
            toDoArray.append(source.toDoItem)
            tableview.insertRows(at: [newIndexPath], with: .bottom)
            tableview.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            
        }
        
    }
    
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        
    }
    
}

