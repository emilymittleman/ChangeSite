//
//  SettingsTableViewController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var viewModel: SettingsViewModel!
    var notificationManager = NotificationManager.shared
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var daysBtwn: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        daysBtwn.text = Int(sender.value).description
        viewModel.updatePumpSite(daysBtwnChanges: Int(sender.value))
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
        stepper.minimumValue = 1
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
        
        // ----- Update the view with reminder data (startDate, daysBtwn, & reminders) -----
        startDate.text = viewModel.formattedStartDate()
        daysBtwn.text = viewModel.pumpSiteDaysBtwnString()
        stepper.value = viewModel.pumpSiteDaysBtwn()
        setReminderFrequencyText()
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
    
    func setReminderFrequencyText() {
        let reminderLabels = [occurrence0, occurrence1, occurrence2, occurrence3, occurrence4]
        let reminderFrequencyStrings = viewModel.reminderFrequencyStrings()
        for (reminderLabel, frequencyString) in zip(reminderLabels, reminderFrequencyStrings) {
            reminderLabel?.text = frequencyString
        }
    }
    
    // NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? StartDateController {
            nextViewController.pumpSiteManager = viewModel.pumpSiteManager
        }
        else if let nextViewController = segue.destination as? ReminderFrequencyController,
            let index = tableView.indexPathForSelectedRow?.row {
            // Will only actually be prompted first time user opens app
            if !NotificationManager.shared.notificationsEnabled() {
                NotificationManager.shared.requestAuthorization { _ in }
            }
            nextViewController.reminderType = viewModel.reminderTypeAtIndex(index)!
            nextViewController.remindersManager = viewModel.remindersManager
        }
    }
    
    // Swift
    @IBAction func unwindToContainerVC(_ segue: UIStoryboardSegue) {
    }

    class func viewController(pumpSiteManager: PumpSiteManager, remindersManager: RemindersManager) -> SettingsTableViewController {
        let viewModel = SettingsViewModel(pumpSiteManager: pumpSiteManager, remindersManager: remindersManager)
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsTableViewController") as! SettingsTableViewController
        vc.viewModel = viewModel
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
