//
//  ReminderManager.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 7/16/20.
//  Copyright © 2020 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

class ReminderManager {
    static let shared: ReminderManager = ReminderManager()
    var reminder: Reminder!;
    
    private init() {
        // Set up reminder if it exists in storage, otherwise set up default values
        self.retrieveFromStorage()
    }
    
    // Initialize array to the 5 default reminder notification types that came with the app
    private func setDefaultValues() {
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let minutesQuarter = Int(floor(Double(minutes)/15.0) * 15) % 60
        let startingDate = Calendar.current.date(bySettingHour: hours, minute: minutesQuarter, second: 0, of: date)!
        
        self.reminder = Reminder(startDate: startingDate, daysBtwn: 4)
        
        self.saveToStorage()
    }
    
    // Update a certain notification in UserDefaults & self
    func mutateNotification(newReminder: Reminder) {
        self.reminder.startDate = newReminder.startDate
        self.reminder.daysBtwn = newReminder.daysBtwn
        
        self.saveToStorage()
    }
    
    func saveToStorage(reminder: Reminder) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(reminder), forKey: "reminder")
    }
    
    // Overloaded saveToUserDefaults() in order to store self.reminderNotifications in UserDefaults
    func saveToStorage() {
        self.saveToStorage(reminder: self.reminder)
    }
    
    func retrieveFromStorage() -> Reminder {
        if (UserDefaults.standard.object(forKey: "reminder") != nil) {
            //
        }
        
        if let reminderData = UserDefaults.standard.object(forKey: "reminder") {
            if let reminder = try? PropertyListDecoder().decode(Reminder.self, from: reminderData as! Data) {
                self.reminder = reminder
            }
        } else {
            self.setDefaultValues()
        }
        
        return self.reminder
    }
    
}
