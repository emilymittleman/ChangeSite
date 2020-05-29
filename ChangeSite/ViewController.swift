//
//  ViewController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

// WELCOME PAGE
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //UserDefaults.standard.set(true, forKey: "newUser")
        //let newUser = UserDefaults.standard.object(forKey: "newUser") as! Bool
        let newUser = UserDefaults.standard.object(forKey: "newUser")
        
        // if newUser is false, go to landingScreen, but if it's nil, then they are a newUser
        // if (newUser != nil)
        // if (newUser == false)
        // if (newUser != true)
        if(newUser != nil) { //skip welcome screen & go to landing page
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "LandingScreen") as UIViewController?
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInPage
        }
        else {
            // set default values for Reminder class & ReminderNotification
            let date = Date()
            let calendar = Calendar.current
            let hours = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let minutesQuarter = Int(floor(Double(minutes)/15.0) * 15) % 60
            let startingDate = Calendar.current.date(bySettingHour: hours, minute: minutesQuarter, second: 0, of: date)!
            
            let reminder = Reminder(startDate: startingDate, daysBtwn: 4)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(reminder), forKey: "reminder")
            
            // create ReminderNotifications
            let freq = Calendar.current.date(bySettingHour: 0, minute: 5, second: 0, of: Date())!
            
            let oneDayBefore = ReminderNotification(occurrence: "none", soundOn: false, frequency: freq)
            let dayOf = ReminderNotification(occurrence: "single", soundOn: false, frequency: freq)
            let oneDayAfter = ReminderNotification(occurrence: "repeating", soundOn: false, frequency: freq)
            let twoDaysAfter = ReminderNotification(occurrence: "repeating", soundOn: false, frequency: freq)
            let threeDaysAfter = ReminderNotification(occurrence: "repeating", soundOn: false, frequency: freq)
            
            // make a list of ReminderNotifications and store it in UserDefaults as a data structure to hold all the reminderNotifications
            let reminderNotifications = [oneDayBefore, dayOf, oneDayAfter, twoDaysAfter, threeDaysAfter]
            UserDefaults.standard.set(try? PropertyListEncoder().encode(reminderNotifications), forKey: "reminderNotifications")
            
            let whichNotification = ReminderNotificationPressed(name: "segue1")
            UserDefaults.standard.set(try? PropertyListEncoder().encode(whichNotification), forKey: "whichNotification")
        }
        
 
    }

}

//let vc = self.storyboard?.instantiateViewController(withIdentifier: "LandingScreen") as UIViewController?
//self.show(vc!, sender: vc)
