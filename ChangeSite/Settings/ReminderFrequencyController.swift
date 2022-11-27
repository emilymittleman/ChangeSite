//
//  ReminderFrequencyController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class ReminderFrequencyController: UIViewController {
    
    var notificationManager = NotificationManager.shared
    var reminderType: ReminderType!
    var remindersManager: RemindersManager!
    
    @IBOutlet weak var reminderFrequencyLabel: UILabel!
    
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    @IBOutlet weak var remindMeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonPressed(_ sender: Any) {
        let frequency = reminderFrequencyFromIndex(segmentedControl.selectedSegmentIndex)
        remindersManager.updateReminder(type: reminderType, frequency: frequency)
        remindersManager.updateReminder(type: reminderType, soundOn: soundSwitch.isOn)
        remindersManager.updateReminder(type: reminderType, repeatingFrequency: getRepeatingFromDatePicker())
        
        if notificationManager.notificationsEnabled() {
            notificationManager.removeScheduledNotification(reminderType: reminderType)
            notificationManager.scheduleNotification(reminderType: reminderType)
        }
        performSegue(withIdentifier: "unwindReminderToSettings", sender: self)
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: Any) {
        if !notificationManager.notificationsEnabled() {
            segmentedControl.selectedSegmentIndex = 0
            let alertController = configureNotificationsAlertPopup()
            self.present(alertController, animated: true, completion: nil)
            // after returning to app, refresh notificationManager.fetchNotificationSettings() so that settings reload
            return
        }
        
        let frequency = reminderFrequencyFromIndex(segmentedControl.selectedSegmentIndex)
        hideViewsForReminderFrequency(frequency)
        
        saveButton.isHidden = false
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        soundSwitch.setOn(soundSwitch.isOn, animated: true)
        
        saveButton.isHidden = false
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        datePicker.date = getRepeatingFromDatePicker()
        
        saveButton.isHidden = false
    }
    
    // -------------- SET UP --------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        notificationManager.fetchNotificationSettings()
        loadSetUp()
    }
    
    // MARK: Private helper functions
    
    private func updateUI() {
        // Background color
        let mode = traitCollection.userInterfaceStyle
        view.backgroundColor = UIColor.background(mode)
        // Label fonts
        reminderFrequencyLabel.font = UIFont(name: "Rubik-Medium", size: 30)
        soundLabel.font = UIFont(name: "Rubik-Medium", size: 26)
        remindMeLabel.font = UIFont(name: "Rubik-Medium", size: 26)
        saveButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
        // Label colors
        reminderFrequencyLabel.textColor = UIColor.charcoal(mode)
        soundLabel.textColor = UIColor.charcoal(mode)
        remindMeLabel.textColor = UIColor.charcoal(mode)
        saveButton.setTitleColor(UIColor.charcoal(mode), for: .normal)
        saveButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)
        
        // Add underline to label
        let border = UIView()
        border.backgroundColor = UIColor.lightBlue
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: reminderFrequencyLabel.frame.size.height-2, width: reminderFrequencyLabel.frame.size.width, height: 2)
        reminderFrequencyLabel.addSubview(border)
    }
    
    private func loadSetUp() {
        // reminder frequency
        switch remindersManager.getFrequency(type: reminderType) {
        case .none:
            segmentedControl.selectedSegmentIndex = 0
        case .single:
            segmentedControl.selectedSegmentIndex = 1
        case .repeating:
            segmentedControl.selectedSegmentIndex = 2
        }
        hideViewsForReminderFrequency(remindersManager.getFrequency(type: reminderType))
        // sound
        soundSwitch.setOn(remindersManager.getSoundOn(type: reminderType), animated: false)
        // frequency
        datePicker.date = remindersManager.getRepeatingFrequency(type: reminderType)
        // save button
        saveButton.isHidden = true
    }
    
    private func hideViewsForReminderFrequency(_ frequency: ReminderFrequency) {
        switch frequency {
        case .none:
            soundLabel.isHidden = true
            soundSwitch.isHidden = true
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
        case .single:
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
        case .repeating:
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = false
            datePicker.isHidden = false
        }
    }
    
    private func reminderFrequencyFromIndex(_ index: Int) -> ReminderFrequency {
        if index == 1 { return .single }
        if index == 2 { return .repeating }
        return .none
    }
    
    private func getRepeatingFromDatePicker() -> Date {
        let date = datePicker.date
        let currentDate = Date()
        let hours = Calendar.current.component(.hour, from: date)
        let minutes = Calendar.current.component(.minute, from: date)
        let repeatingFrequency = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: currentDate)!
        return repeatingFrequency
    }
    
    private func configureNotificationsAlertPopup() -> UIAlertController {
        let alertController = UIAlertController(title: "Enable Notifications",
                                                message: "In order to set up reminders, please go to settings to enable notifications.",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction!) in }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action: UIAlertAction!) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        return alertController
    }

}
