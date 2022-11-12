//
//  ReminderFrequencyController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class ReminderFrequencyController: UIViewController {
    
    var pumpSite: PumpSite = PumpSiteManager.shared.pumpSite
    var notificationManager = NotificationManager.shared
    var reminderNotification: ReminderNotification = ReminderNotification(type: .dayOf) //default holder, because value gets set from segue
    
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    @IBOutlet weak var remindMeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
            // update reminderNotification
            self.reminderNotification.frequency = .none
        case 1:
            // single - show sound
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = true
            datePicker.isHidden = true
            // update reminderNotification
            self.reminderNotification.frequency = .single
        case 2:
            // repeating - show sound & datePicker
            soundLabel.isHidden = false
            soundSwitch.isHidden = false
            remindMeLabel.isHidden = false
            datePicker.isHidden = false
            // update reminderNotification
            self.reminderNotification.frequency = .repeating
        default:
            break
        }
        
        ReminderNotificationsManager.shared.mutateNotification(newReminderNotif: self.reminderNotification)
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        soundSwitch.setOn(soundSwitch.isOn, animated: true)
        self.reminderNotification.soundOn = soundSwitch.isOn
        
        ReminderNotificationsManager.shared.mutateNotification(newReminderNotif: self.reminderNotification)
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        let date = datePicker.date
        let currentDate = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let repeatingFrequency = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: currentDate)!
        datePicker.date = repeatingFrequency
        
        self.reminderNotification.repeatingFrequency = repeatingFrequency
        
        ReminderNotificationsManager.shared.mutateNotification(newReminderNotif: self.reminderNotification)
    }
    
    // -------------- SET UP --------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //soundLabel.font = UIFont(name: "Helectiva", size: soundLabel.font.pointSize)
        //soundLabel.font = UIFont(name: "DINAlternate-Bold", size: soundLabel.font.pointSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.pumpSite = PumpSiteManager.shared.retrieveFromStorage()
        
        loadSetUp()
        
        view.backgroundColor = UIColor.systemBackground
    }
    
    func loadSetUp() {
        // reminder frequency
        switch self.reminderNotification.frequency {
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
        soundSwitch.setOn(self.reminderNotification.soundOn, animated: false)
        // frequency
        datePicker.date = self.reminderNotification.repeatingFrequency
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
