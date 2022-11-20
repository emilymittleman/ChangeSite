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
    let remindersManager: RemindersManager
    
    init(pumpSiteManager: PumpSiteManager, remindersManager: RemindersManager) {
        self.pumpSiteManager = pumpSiteManager
        self.remindersManager = remindersManager
    }
    
    public func retrieveDataFromStorage() {
        pumpSiteManager.retrieveFromStorage()
        remindersManager.retrieveFromStorage()
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
        return ReminderType.allCases.map { remindersManager.getFrequency(type: $0).rawValue }
    }
    
    public func pumpSiteDaysBtwn() -> Double {
        return Double(self.pumpSiteManager.getDaysBtwn())
    }
    
    public func pumpSiteDaysBtwnString() -> String {
        return String(self.pumpSiteManager.getDaysBtwn())
    }
    
    // MARK: Dependency injectors
    
    public func reminderTypeAtIndex(_ index: Int) -> ReminderType? {
        let types = ReminderType.allCases
        if index >= 0 && index < types.count {
            return types[index]
        }
        return nil
    }
    
    
}
