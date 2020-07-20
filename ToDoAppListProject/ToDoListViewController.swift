//
//  ViewController.swift
//  ToDoAppListProject
//
//  Created by marvin evins on 6/1/20.
//  Copyright © 2020 websavantmedia. All rights reserved.
//

import UIKit
import UserNotifications

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
        authorizeLocalNotifications()
        
    }
    
    func authorizeLocalNotifications(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else{
                print("error: \(String(describing: error?.localizedDescription))")
                return
            }
            if granted{
                print("notifications authorization granted")
            }
            else{
                print("the user has dened notificaions")
            }
        }
    }
    
    func setNotifications(){
        guard toDoItems.count > 0 else {
            return
        }
        //remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // and lets recreate them with the updated data that we just saved
        
        for index in 0..<toDoItems.count {
            if toDoItems[index].reminderSet {
                let toDoItem = toDoItems[index]
                toDoItems[index].notificationID = setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
    }
    
    
    
    func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date)-> String{
        //create content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        //create trigger
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //create request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        //register request with the notification center
        UNUserNotificationCenter.current().add(request){(error) in
            if let error = error{
                print("Error: \(error.localizedDescription)")
            } else{
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
            
        }
        return notificationID
        
        
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
        
//        let toDoItem = toDoItems.first!
//        let notificationID = setCalendarNotification(title: toDoItem.name, subtitle: "subtitle would go here", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
        setNotifications()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print("numbers of rows in section was just called \(toDoArray.count)")
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
            let newIndexPath = IndexPath(row: toDoItems.count, section:0)
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

