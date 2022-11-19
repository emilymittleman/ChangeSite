//
//  SettingsTableViewController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, InjectsPumpData {
    
    var pumpSiteManager: PumpSiteManager!
    
    var settingsViewModel: SettingsViewModel!
    var notificationManager = NotificationManager.shared
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var daysBtwn: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        daysBtwn.text = Int(sender.value).description
        settingsViewModel.updatePumpSite(daysBtwnChanges: Int(sender.value))
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
        
        settingsViewModel.retrieveDataFromStorage()
        // ----- Update the view with reminder data (startDate, daysBtwn, & reminderNotifications) -----
        startDate.text = settingsViewModel.formattedStartDate()
        daysBtwn.text = settingsViewModel.pumpSiteDaysBtwnString()
        stepper.value = settingsViewModel.pumpSiteDaysBtwn()
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
    
    func setReminderNotificationText() {
        let reminderLabels = [occurrence0, occurrence1, occurrence2, occurrence3, occurrence4]
        let reminderFrequencyStrings = settingsViewModel.reminderFrequencyStrings()
        for (reminderLabel, frequencyString) in zip(reminderLabels, reminderFrequencyStrings) {
            reminderLabel?.text = frequencyString
        }
    }
    
    // NAVIGATION -- figure out a way to send which segue was pressed so you know which reminderNotification to change
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? StartDateController {
            nextViewController.pumpSiteManager = settingsViewModel.pumpSiteManager
        }
        else if let nextViewController = segue.destination as? ReminderFrequencyController,
            let index = tableView.indexPathForSelectedRow?.row {
            // Will only actually be prompted first time user opens app
            /*if !NotificationManager.shared.notificationsEnabled() {
                NotificationManager.shared.requestAuthorization { _ in
                }
            }*/
            nextViewController.reminderNotification = settingsViewModel.reminderAtIndex(index)!
        }
    }
    
    // Swift
    @IBAction func unwindToContainerVC(_ segue: UIStoryboardSegue) {
    }

    class func viewController(pumpSiteManager: PumpSiteManager, reminders: [ReminderNotification]) -> SettingsTableViewController {
        let settingsViewModel = SettingsViewModel(pumpSiteManager: pumpSiteManager, reminders: reminders)
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsTableViewController") as! SettingsTableViewController
        vc.settingsViewModel = settingsViewModel
        return vc
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
