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
    var startDate: Date { get { return pumpSite.startDate } }
    var daysBtwn: Int { get { return pumpSite.daysBtwn } }
    var endDate: Date { get { return pumpSite.endDate } }
    var overdue: Bool { get { return pumpSite.overdue } }
    
    init() {
        self.retrieveFromStorage()
    }
    
    func retrieveFromStorage() {
        if let pumpSiteData = UserDefaults.standard.object(forKey: UserDefaults.Keys.pumpSite.rawValue),
           let pumpSite = try? PropertyListDecoder().decode(PumpSite.self, from: pumpSiteData as! Data) {
                self.pumpSite = pumpSite
        } else {
            self.setDefaultValues()
        }
    }
    
    // Initialize pumpSite start date to current date & daysBtwn to 4
    private func setDefaultValues() {
        // Database compliance: allows new user with default pumpSite to set up startDate since newStartDate must be > oldStartDate
        let newUser = UserDefaults.standard.bool(forKey: UserDefaults.Keys.newUser.rawValue)
        let date = newUser ? Date(timeIntervalSince1970: 0) : Date()
        let startingDate = formatDate(date)
        self.pumpSite = PumpSite(startDate: startingDate, daysBtwn: 4)
        self.saveToStorage()
    }
    
    // MARK: Mutators, Setters, and Updaters
    
    public func updatePumpSite(daysBtwnChanges: Int) {
        if daysBtwnChanges >= 1 {
            self.pumpSite.setDaysBtwn(daysBtwn: daysBtwnChanges)
            self.saveToStorage()
        }
    }
    
    public func updatePumpSite(startDate: Date) {
        if startDate > pumpSite.startDate {
            self.pumpSite.setStartDate(startDate: startDate)
            self.saveToStorage()
        }
    }
    
    // Overloaded saveToStorage() in order to store self.pumpSite in UserDefaults
    func saveToStorage() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(pumpSite), forKey: UserDefaults.Keys.pumpSite.rawValue)
    }
}

fileprivate class PumpSite: Codable {
    private(set) var startDate: Date
    private(set) var daysBtwn: Int
    private(set) var endDate: Date
    var overdue: Bool {
        get {
            return self.endDate < Date()
        }
    }
    
    init(startDate: Date, daysBtwn: Int) {
        self.startDate = startDate
        self.daysBtwn = daysBtwn
        self.endDate = startDate
        self.endDate.addTimeInterval(TimeInterval(daysBtwn * AppConstants.kSecondsPerDay))
    }
    
    // MARK: SETTERS
    func setStartDate(startDate: Date) {
        self.startDate = startDate
        // reset endDate
        self.endDate = startDate
        self.endDate.addTimeInterval(TimeInterval(daysBtwn * AppConstants.kSecondsPerDay))
    }
    
    // need to update CoreData with new expiredDate too
    func setDaysBtwn(daysBtwn: Int) {
        self.daysBtwn = daysBtwn
        // reset endDate
        self.endDate = startDate
        self.endDate.addTimeInterval(TimeInterval(daysBtwn * AppConstants.kSecondsPerDay))
    }
}

