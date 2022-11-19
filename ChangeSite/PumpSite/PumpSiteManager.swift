//
//  ReminderManager.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 7/16/20.
//  Copyright © 2020 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

class PumpSiteManager {
    
    private var pumpSite: PumpSite!;
    
    init() {
        // Set up pumpSite if it exists in storage, otherwise set up default values
        self.retrieveFromStorage()
    }
    
    func retrieveFromStorage() {
        // Not sure which conditional works for testing if "reminder" is nil:
        //if (UserDefaults.standard.object(forKey: "reminder") != nil)
        if let pumpSiteData = UserDefaults.standard.object(forKey: "pumpSite") {
            if let pumpSite = try? PropertyListDecoder().decode(PumpSite.self, from: pumpSiteData as! Data) {
                self.pumpSite = pumpSite
            }
        } else { self.setDefaultValues() }
    }
    
    // Initialize array to the 5 default reminder notification types that came with the app
    private func setDefaultValues() {
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let minutesQuarter = Int(floor(Double(minutes)/15.0) * 15) % 60
        let startingDate = Calendar.current.date(bySettingHour: hours, minute: minutesQuarter, second: 0, of: date)!
        
        
        self.pumpSite = PumpSite(startDate: startingDate, daysBtwn: 4)
        
        self.saveToStorage()
    }
    
    // MARK: GETTERS
    
    func getStartDate() -> Date { return self.pumpSite.getStartDate() }
    func getEndDate() -> Date { return self.pumpSite.getEndDate() }
    func getDaysBtwn() -> Int { return self.pumpSite.getDaysBtwn() }
    func isOverdue() -> Bool { return self.pumpSite.isOverdue() }
    
    // MARK: Mutators, Setters, and Updaters
    
    public func updatePumpSite(daysBtwnChanges: Int) {
        if daysBtwnChanges >= 1 {
            self.pumpSite.setDaysBtwn(daysBtwn: daysBtwnChanges)
            self.saveToStorage()
        }
    }
    
    public func updatePumpSite(startDate: Date) {
        if startDate > pumpSite.getStartDate() {
            self.pumpSite.setStartDate(startDate: startDate)
            self.saveToStorage()
        }
    }
    
    func saveToStorage(pumpSite: PumpSite) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(pumpSite), forKey: "pumpSite")
    }
    
    // Overloaded saveToStorage() in order to store self.pumpSite in UserDefaults
    func saveToStorage() {
        self.saveToStorage(pumpSite: self.pumpSite)
    }
    
    // Update a certain notification in UserDefaults & self
    /*func mutateNotification(newPumpSite: PumpSite) {
        self.pumpSite.setStartDate(startDate: newPumpSite.getStartDate())
        self.pumpSite.setDaysBtwn(daysBtwn: newPumpSite.getDaysBtwn())
        
        self.saveToStorage()
    }*/
    
}
