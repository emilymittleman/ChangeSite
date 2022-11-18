//
//  SettingsTableViewController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var settingsViewModel: SettingsViewModel!
    
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
    
    @IBOutlet weak var newSiteCell: UITableViewCell!
    @IBOutlet weak var daysBtwnCell: UITableViewCell!
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
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.pumpSite = PumpSiteManager.shared.retrieveFromStorage()
        self.reminderNotifications = ReminderNotificationsManager.shared.retrieveFromStorage()
        
        // Special case: If user turned off notifications while app was running, need to reset reminders
        /*if !notificationManager.notificationsEnabled() {
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
    
    private func updateUI() {
        // Background color
        let mode = traitCollection.userInterfaceStyle
        view.backgroundColor = UIColor.background(mode)
        let cells: [UITableViewCell] = [newSiteCell, daysBtwnCell, cell1, cell2, cell3, cell4, cell5]
        for cell in cells {
            cell.backgroundColor = UIColor.background(mode)
            for subview in cell.contentView.subviews {
                if let label = subview as? UILabel {
                    label.textColor = UIColor.charcoal(mode)
                    label.font = UIFont(name: "Rubik-Regular", size: 17)
                }
            }
        }
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
    
    // Swift
    @IBAction func unwindToContainerVC(_ segue: UIStoryboardSegue) {
        
    }

    class func viewController() -> SettingsTableViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsTableViewController") as! SettingsTableViewController
    }
    
    // MARK: - Table view data source
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.background(traitCollection.userInterfaceStyle)
        return cell
    } */
    
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
    
    // MARK: - Navigation
    

}
