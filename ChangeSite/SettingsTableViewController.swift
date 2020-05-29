//
//  SettingsTableViewController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    // variables ... I wanted all of these to have Label in the variable name but they don't
    // and I don't want to break the connection
    //   wanna do this bc Reminder's instance variables are the same as the label's variable names
    
    // need to define each reminder inside the function so it's a local variable
    func getReminder() -> Reminder {
        let reminder = ( try? PropertyListDecoder().decode(Reminder.self, from: UserDefaults.standard.object(forKey: "reminder") as! Data) )!
        return reminder
    }
    func saveReminder(reminder: Reminder) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(reminder), forKey: "reminder")
    }
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var daysBtwn: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        var reminder = getReminder()
        daysBtwn.text = Int(sender.value).description
        reminder.daysBtwn = Int(sender.value)
        saveReminder(reminder: reminder)
    }
    
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var cell4: UITableViewCell!
    @IBOutlet weak var cell5: UITableViewCell!
    
    
    @IBOutlet weak var occurrence0: UILabel!
    @IBOutlet weak var occurrence1: UILabel!
    @IBOutlet weak var occurrence2: UILabel!
    @IBOutlet weak var occurrence3: UILabel!
    @IBOutlet weak var occurrence4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reminder = getReminder()

        stepper.autorepeat = true
        
        // set the startDate text
        setStartDateLabel()
        // set the days between number
        daysBtwn.text = String(reminder.daysBtwn)
        // set the labels for each reminderNotification settings (none, single, or repeating)
        setReminderNotificationText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // calls this function every time the settings screen appears (or reappears like if you hit back)
        // pretty sure I can just use this method & not viewDidLoad()
        super.viewWillAppear(true)
        
        let reminder = getReminder()
        
        // set the startDate text
        setStartDateLabel()
        // you have to update reminder
        daysBtwn.text = String(reminder.daysBtwn)
        // set the labels for each reminderNotification settings (none, single, or repeating)
        setReminderNotificationText()
    }
    
    func setStartDateLabel() {
        let reminder = getReminder() //reminder might've been updated in UserDefaults, so you have to get it from there again
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: reminder.startDate)
        startDate.text = strDate
    }
    
    func setReminderNotificationText() {
        let reminderNotifications = (try? PropertyListDecoder().decode([ReminderNotification].self, from: UserDefaults.standard.object(forKey: "reminderNotifications") as! Data))!
        occurrence0.text = reminderNotifications[0].occurrence
        occurrence1.text = reminderNotifications[1].occurrence
        occurrence2.text = reminderNotifications[2].occurrence
        occurrence3.text = reminderNotifications[3].occurrence
        occurrence4.text = reminderNotifications[4].occurrence
    }
    
    // NAVIGATION -- figure out a way to send which segue was pressed so you know which reminderNotification to change
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let nextViewController = segue.destination as? ReminderFrequencyController {
            //nextViewController.whichNotification = ReminderNotificationPressed(name: segue.identifier!)
            
            if (segue.identifier == "segue1") {
                nextViewController.index = 0
            }
            else if (segue.identifier == "segue2") {
                nextViewController.index = 1
            }
            else if (segue.identifier == "segue3") {
                nextViewController.index = 2
            }
            else if (segue.identifier == "segue4") {
                nextViewController.index = 3
            }
            else {
                nextViewController.index = 4
            }
        }
        
    }
    

    // MARK: - Table view data source
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
 */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    

}
