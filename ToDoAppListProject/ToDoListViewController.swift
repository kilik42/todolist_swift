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
    
    var toDoItems: [ToDoItem] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
        loadData()
        
        
    }

    func loadData(){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
               
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathComponent("todos").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        
        let jsonDecoder = JSONDecoder()
        
        do{
            toDoItems = try jsonDecoder.decode(Array<ToDoItem>.self, from : data)
            tableview.reloadData()
        }catch{
            print("could not load data: \(error.localizedDescription)")
        }
    }
    
    
    //saving data to ios device
    func saveData(){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathComponent("todos").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(toDoItems)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
            
        }catch{
            print(" error: could not save data \(error.localizedDescription)")
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numbers of rows in section was just called \(toDoArray.count)")
        return toDoItems.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoItems[indexPath.row].name
        
        return cell
       }
    
    //send data to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = tableview.indexPathForSelectedRow!
            destination.toDoItem = toDoItems[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableview.indexPathForSelectedRow{
                tableview.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }

    @IBAction func unwindFromDetail(segue: UIStoryboardSegue){
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = tableview.indexPathForSelectedRow{
            toDoItems[selectedIndexPath.row] = source.toDoItem
            tableview.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else{
            let newIndexPath = IndexPath(row: toDoArray.count, section:0)
            toDoItems.append(source.toDoItem)
            tableview.insertRows(at: [newIndexPath], with: .bottom)
            tableview.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            
        }
        saveData()
    }
    
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if tableview.isEditing{
            tableview.setEditing(false, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = true
        }else{
            tableview.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    
    
    
    //commit editing stylee
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoItems[sourceIndexPath.row]
        toDoItems.remove(at: sourceIndexPath.row)
        toDoItems.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
}

