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
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            remindersManager.updateReminder(type: reminderType, frequency: .none)
        case 1:
            remindersManager.updateReminder(type: reminderType, frequency: .single)
        case 2:
            remindersManager.updateReminder(type: reminderType, frequency: .repeating)
        default:
            break
        }
        
        remindersManager.updateReminder(type: reminderType, soundOn: soundSwitch.isOn)
        remindersManager.updateReminder(type: reminderType, repeatingFrequency: getRepeatingFromDatePicker())
        performSegue(withIdentifier: "unwindReminderToSettings", sender: self)
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: Any) {
        // TODO: If user tapped "Don't Allow" notifications but try to turn them on, prompt them to allow notifications in settings
        // guarantee that this is the only possibility if notifications are not enabled and they try changing a reminder
        // task-n
        /*if !notificationManager.notificationsEnabled() {
            // add a custom alert with this completion handler
            if let settingsURL = URL(string: UIApplication.openSettingsURLString){
               UIApplication.shared.open(settingsURL)
            }
            // after returning to app, refresh notificationManager.fetchNotificationSettings() so that settings reload
        }*/
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            // none
            soundLabel.isHidden = true
            soundSwitch.isHidden = true
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
        case 1:
            // single - show sound
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
        case 2:
            // repeating - show sound & datePicker
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = false
            datePicker.isHidden = false
        default:
            break
        }
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
    
    private func getRepeatingFromDatePicker() -> Date {
        let date = datePicker.date
        let currentDate = Date()
        let hours = Calendar.current.component(.hour, from: date)
        let minutes = Calendar.current.component(.minute, from: date)
        let repeatingFrequency = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: currentDate)!
        return repeatingFrequency
    }
    
    // -------------- SET UP --------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadSetUp()
    }
    
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
            // sounds & frequency
            soundLabel.isHidden = true
            soundSwitch.isHidden = true
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
        case .single:
            segmentedControl.selectedSegmentIndex = 1
            // sounds & frequency
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
        case .repeating:
            segmentedControl.selectedSegmentIndex = 2
            // sounds & frequency
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = false
            datePicker.isHidden = false
        }
        // sound
        soundSwitch.setOn(remindersManager.getSoundOn(type: reminderType), animated: false)
        // frequency
        datePicker.date = remindersManager.getRepeatingFrequency(type: reminderType)
        // save button
        saveButton.isHidden = true
    }
    
    // task-notification
    /*override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let reminderNotification = self.reminderNotification,
           notificationManager.notificationsEnabled() {
            notificationManager.removeScheduledNotification(reminder: reminderNotification)
            notificationManager.scheduleNotification(reminder: reminderNotification, pumpExiredDate: pumpSite.getEndDate())
        }
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
