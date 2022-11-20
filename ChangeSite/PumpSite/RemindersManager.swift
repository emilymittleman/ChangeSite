//
//  ReminderNotificationsManager.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 7/16/20.
//  Copyright © 2020 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

class RemindersManager {
    
    // private var reminders: [Reminder]!;
    // private var reminderIndices = [ReminderType:Int]()
    private var reminders = [ReminderType:Reminder]()
    
    init() {
        self.retrieveFromStorage()
        // self.initializeMap()
    }
    
    func retrieveFromStorage() {
        if let remindersData = UserDefaults.standard.object(forKey: UserDefaults.Keys.reminders.rawValue),
           let reminders = try? PropertyListDecoder().decode([ReminderType:Reminder].self, from: remindersData as! Data) {
                self.reminders = reminders
        } else {
            self.setDefaultValues()
        }
    }
    
    /*private func initializeMap() {
        for reminder in reminders {
            reminders[reminder.type] = reminder
        }
    }*/
    
    // Initialize array to the 5 default reminder notification types that came with the app
    private func setDefaultValues() {
        for type in ReminderType.allCases {
            self.reminders[type] = Reminder(type: type)
        }
        self.saveToStorage()
        /*let oneDayBefore = Reminder(type: .oneDayBefore)
        let dayOf = Reminder(type: .dayOf)
        let oneDayAfter = Reminder(type: .oneDayAfter)
        let twoDaysAfter = Reminder(type: .twoDaysAfter)
        let threeDaysAfter = Reminder(type: .extendedDaysAfter)
        self.reminders = [oneDayBefore, dayOf, oneDayAfter, twoDaysAfter, threeDaysAfter]*/
    }
    
    // MARK: GETTERS
    
    func getFrequency(type: ReminderType) -> ReminderFrequency { return reminders[type]!.frequency }
    func getSoundOn(type: ReminderType) -> Bool { return reminders[type]!.soundOn }
    func getRepeatingFrequency(type: ReminderType) -> Date { return reminders[type]!.repeatingFrequency }
    
    // MARK: Mutators, Setters, and Updaters
    
    public func updateReminder(type: ReminderType, frequency: ReminderFrequency) {
        reminders[type]!.frequency = frequency
        self.saveToStorage()
    }
    
    public func updateReminder(type: ReminderType, soundOn: Bool) {
        reminders[type]!.soundOn = soundOn
        self.saveToStorage()
    }
    
    public func updateReminder(type: ReminderType, repeatingFrequency: Date) {
        reminders[type]!.repeatingFrequency = repeatingFrequency
        self.saveToStorage()
    }
    
    // Update a certain notification in UserDefaults & self
    /*func mutateNotification(newReminderNotif: Reminder) {
        for reminder in self.reminders {
            if reminder.type == newReminderNotif.type {
                reminder.frequency = newReminderNotif.frequency
                reminder.soundOn = newReminderNotif.soundOn
                reminder.repeatingFrequency = newReminderNotif.repeatingFrequency
            }
        }
        
        self.saveToStorage()
    }*/
    
    func saveToStorage() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(reminders), forKey: UserDefaults.Keys.reminders.rawValue)
    }
    
}
