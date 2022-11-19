//
//  SettingsViewModel.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/17/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation

class SettingsViewModel {
    
    let pumpSiteManager: PumpSiteManager
    let reminders: [ReminderNotification]
    
    init(pumpSiteManager: PumpSiteManager, reminders: [ReminderNotification]) {
        self.pumpSiteManager = pumpSiteManager
        self.reminders = reminders
    }
    
    public func retrieveDataFromStorage() {
        pumpSiteManager.retrieveFromStorage()
        // retrieve reminders
    }
    
    // MARK: Mutators
    
    public func updatePumpSite(daysBtwnChanges: Int) {
        self.pumpSiteManager.updatePumpSite(daysBtwnChanges: daysBtwnChanges)
    }
    
    public func updatePumpSite(startDate: Date) {
        self.pumpSiteManager.updatePumpSite(startDate: startDate)
    }
    
    // MARK: Strings
    
    public func formattedStartDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter.string(from: self.pumpSiteManager.getStartDate())
    }
    
    public func reminderFrequencyStrings() -> [String] {
        return self.reminders.map { $0.frequency.rawValue }
    }
    
    public func pumpSiteDaysBtwn() -> Double {
        return Double(self.pumpSiteManager.getDaysBtwn())
    }
    
    public func pumpSiteDaysBtwnString() -> String {
        return String(self.pumpSiteManager.getDaysBtwn())
    }
    
    // MARK: Dependency injectors
    
    public func reminderAtIndex(_ index: Int) -> ReminderNotification? {
        if index >= 0 && index < self.reminders.count {
            return self.reminders[index]
        }
        return nil
    }
    
    
}

