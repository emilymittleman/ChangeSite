//
//  SettingsTableViewController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var pumpSite: PumpSite = PumpSiteManager.shared.pumpSite
    var reminderNotifications: [ReminderNotification] = ReminderNotificationsManager.shared.reminderNotifications
    var notificationManager = NotificationManager.shared
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var daysBtwn: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        daysBtwn.text = Int(sender.value).description
        
        self.pumpSite.setDaysBtwn(daysBtwn: Int(sender.value))
        PumpSiteManager.shared.mutateNotification(newPumpSite: self.pumpSite)
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
        
        stepper.autorepeat = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.pumpSite = PumpSiteManager.shared.retrieveFromStorage()
        self.reminderNotifications = ReminderNotificationsManager.shared.retrieveFromStorage()
        
        // Special case: If user turned off notifications while app was running, need to reset reminders
        /*if !notificationManager.notificationsEnabled() {
            print("this is getting called")
            for reminderNotification in reminderNotifications {
                if reminderNotification.frequency != .none {
                    reminderNotification.frequency = .none
                    ReminderNotificationsManager.shared.mutateNotification(newReminderNotif: reminderNotification)
                    notificationManager.removeAllNotifications()
                }
            }
        }*/
        
        // ----- Update the view with reminder data (startDate, daysBtwn, & reminderNotifications) -----
        setStartDateLabel()
        daysBtwn.text = String(pumpSite.getDaysBtwn())
        stepper.value = Double(pumpSite.getDaysBtwn())
        setReminderNotificationText()
    }
    
    func setStartDateLabel() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: self.pumpSite.getStartDate())
        startDate.text = strDate
    }
    
    func setReminderNotificationText() {
        occurrence0.text = reminderNotifications[0].frequency.rawValue
        occurrence1.text = reminderNotifications[1].frequency.rawValue
        occurrence2.text = reminderNotifications[2].frequency.rawValue
        occurrence3.text = reminderNotifications[3].frequency.rawValue
        occurrence4.text = reminderNotifications[4].frequency.rawValue
    }
    
    // NAVIGATION -- figure out a way to send which segue was pressed so you know which reminderNotification to change
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let nextViewController = segue.destination as? ReminderFrequencyController {
            // Will only actually be prompted first time user opens app
            /*if !NotificationManager.shared.notificationsEnabled() {
                NotificationManager.shared.requestAuthorization { _ in
                }
            }*/
            if (segue.identifier == "segue1") {
                nextViewController.reminderNotification = reminderNotifications[0]
            }
            else if (segue.identifier == "segue2") {
                nextViewController.reminderNotification = reminderNotifications[1]
            }
            else if (segue.identifier == "segue3") {
                nextViewController.reminderNotification = reminderNotifications[2]
            }
            else if (segue.identifier == "segue4") {
                nextViewController.reminderNotification = reminderNotifications[3]
            }
            else {
                nextViewController.reminderNotification = reminderNotifications[4]
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
