//
//  ReminderNotificationsManager.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 7/16/20.
//  Copyright © 2020 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

class ReminderNotificationsManager {
    static let shared: ReminderNotificationsManager = ReminderNotificationsManager()
    var reminderNotifications: [ReminderNotification]!;
    
    private init() {
        self.reminderNotifications = []
        // Set up array if it exists in storage, otherwise set up default values
        self.retrieveFromStorage()
    }
    
    // Initialize array to the 5 default reminder notification types that came with the app
    private func setDefaultValues() {
        let oneDayBefore = ReminderNotification(type: "oneDayBefore")
        let dayOf = ReminderNotification(type: "dayOf")
        let oneDayAfter = ReminderNotification(type: "oneDayAfter")
        let twoDaysAfter = ReminderNotification(type: "twoDaysAfter")
        let threeDaysAfter = ReminderNotification(type: "threeDaysAfter")
        
        // Make a list of ReminderNotifications and store it in UserDefaults as a data structure to hold all the reminderNotifications
        self.reminderNotifications = []
        self.reminderNotifications.append(oneDayBefore)
        self.reminderNotifications.append(dayOf)
        self.reminderNotifications.append(oneDayAfter)
        self.reminderNotifications.append(twoDaysAfter)
        self.reminderNotifications.append(threeDaysAfter)
        
        self.saveToStorage()
    }
    
    // Update a certain notification in UserDefaults & self
    func mutateNotification(newReminderNotif: ReminderNotification) {
        for reminderNotif in self.reminderNotifications {
            if reminderNotif.type == newReminderNotif.type {
                reminderNotif.occurrence = newReminderNotif.occurrence
                reminderNotif.soundOn = newReminderNotif.soundOn
                reminderNotif.frequency = newReminderNotif.frequency
            }
        }
        
        self.saveToStorage()
    }
    
    func saveToStorage(reminderNotifications: [ReminderNotification]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(reminderNotifications), forKey: "reminderNotifications")
    }
    
    // Overloaded saveToUserDefaults() in order to store self.reminderNotifications in UserDefaults
    func saveToStorage() {
        self.saveToStorage(reminderNotifications: self.reminderNotifications)
    }
    
    func retrieveFromStorage() -> [ReminderNotification] {
        if UserDefaults.standard.object(forKey: "reminderNotifications") != nil {
            if let reminderNotifications = try? PropertyListDecoder().decode([ReminderNotification].self, from: UserDefaults.standard.object(forKey: "reminderNotifications") as! Data) {
                self.reminderNotifications = reminderNotifications
            }
        } else { // If it is nil in UserDefaults, set up default values
            self.reminderNotifications = []
            self.setDefaultValues()
        }
        return self.reminderNotifications
    }
    
}
