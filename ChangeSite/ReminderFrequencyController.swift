//
//  ReminderFrequencyController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class ReminderFrequencyController: UIViewController {
    
    func getReminderNotifications() -> [ReminderNotification] {
        return (try? PropertyListDecoder().decode([ReminderNotification].self, from: UserDefaults.standard.object(forKey: "reminderNotifications") as! Data))!
    }
    func saveReminderNotifications(reminderNotifications: [ReminderNotification]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(reminderNotifications), forKey: "reminderNotifications")
    }
    
    var whichNotification = ReminderNotificationPressed(name: "segue1")
    var index = 0
    
    func getReminderNotification() -> ReminderNotification {
        let reminderNotifications = getReminderNotifications()
        return reminderNotifications[index]
    }
    
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    @IBOutlet weak var remindMeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: Any) {
        var reminderNotifications = getReminderNotifications()
        var reminderNotification = getReminderNotification()
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            // none
            soundLabel.isHidden = true
            soundSwitch.isHidden = true
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
            // update reminderNotification
            reminderNotification.occurrence = "none"
        case 1:
            // single - show sound
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
            // update reminderNotification
            reminderNotification.occurrence = "single"
        case 2:
            // repeating - show sound & datePicker
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = false
            datePicker.isHidden = false
            // update reminderNotification
            reminderNotification.occurrence = "repeating"
        default:
            break
        }
        reminderNotifications[index] = reminderNotification
        saveReminderNotifications(reminderNotifications: reminderNotifications)
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        var reminderNotifications = getReminderNotifications()
        var reminderNotification = getReminderNotification()
        
        soundSwitch.setOn(soundSwitch.isOn, animated: true)
        reminderNotification.soundOn = soundSwitch.isOn
        
        reminderNotifications[index] = reminderNotification
        saveReminderNotifications(reminderNotifications: reminderNotifications)
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        var reminderNotifications = getReminderNotifications()
        var reminderNotification = getReminderNotification()
        
        let date = datePicker.date
        let currentDate = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let startingDate = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: currentDate)!
        datePicker.date = startingDate
        reminderNotification.frequency = startingDate
        
        reminderNotifications[index] = reminderNotification
        saveReminderNotifications(reminderNotifications: reminderNotifications)
    }
    
    // -------------- SET UP --------------
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSetUp()
        view.backgroundColor = UIColor.systemBackground
        //soundLabel.font = UIFont(name: "Helectiva", size: soundLabel.font.pointSize)
        //soundLabel.font = UIFont(name: "DINAlternate-Bold", size: soundLabel.font.pointSize)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadSetUp()
        view.backgroundColor = UIColor.systemBackground
    }
    
    func loadSetUp() {
        let reminderNotification = getReminderNotification()
        // reminder frequency
        switch reminderNotification.occurrence {
        case "none":
            segmentedControl.selectedSegmentIndex = 0
            // sounds & frequency
            soundLabel.isHidden = true
            soundSwitch.isHidden = true
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
        case "single":
            segmentedControl.selectedSegmentIndex = 1
            // sounds & frequency
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
        case "repeating":
            segmentedControl.selectedSegmentIndex = 2
            // sounds & frequency
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = false
            datePicker.isHidden = false
        default:
            break
        }
        // sound
        soundSwitch.setOn(reminderNotification.soundOn, animated: false)
        // frequency
        datePicker.date = reminderNotification.frequency
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
