//
//  HomeViewModel.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/20/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

class HomeViewModel {
    
    let pumpSiteManager: PumpSiteManager
    let remindersManager: RemindersManager
    var notificationManager = NotificationManager.shared
    var coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
    var siteDatesProvider = SiteDatesProvider(with: AppDelegate.sharedAppDelegate.coreDataStack.managedContext)
    
    init(pumpSiteManager: PumpSiteManager, remindersManager: RemindersManager) {
        self.pumpSiteManager = pumpSiteManager
        self.remindersManager = remindersManager
    }
    
    // MARK: Getters
    
    public func pumpSiteIsOverdue() -> Bool {
        return pumpSiteManager.overdue
    }
    
    public func pumpSiteEndDate() -> Date {
        return pumpSiteManager.endDate
    }
    
    public func pumpSiteStartDate() -> Date {
        return pumpSiteManager.startDate
    }
    
    // MARK: Mutators
    
    public func endPumpSite(endDate: Date) {
        // UIApplication.shared.applicationIconBadgeNumber = 0
        SiteDates.createOrUpdate(pumpSiteManager: pumpSiteManager, endDate: endDate, with: coreDataStack)
        coreDataStack.saveContext()
        notificationManager.removeAllNotifications()
    }
    
    public func startNewPumpSite(startDate: Date) {
        pumpSiteManager.updatePumpSite(startDate: startDate)
        SiteDates.createOrUpdate(pumpSiteManager: pumpSiteManager, endDate: nil, with: coreDataStack)
        coreDataStack.saveContext()
        notificationManager.scheduleNotifications(reminderTypes: ReminderType.allCases)
    }
    
    public func updateCoreData() {
        // if current site is overdue AND coredata.overdue != current overdue days, update CoreData
        guard let currentSite = siteDatesProvider.getCurrentSite() else {
            print("Database error: could not retrieve current site")
            return
        }
        
        // check daysOverdue (daysOverdue & expiredDate will be updated if daysBtwn changed)
        if pumpSiteManager.overdue {
            let daysOver = signedDaysBetweenDates(from: pumpSiteManager.endDate, to: Date())
            if daysOver != currentSite.daysOverdue {
                SiteDates.createOrUpdate(pumpSiteManager: pumpSiteManager, endDate: nil, with: coreDataStack)
            }
        }
    }
    
    // MARK: Strings
    
    public func getNextChangeText() -> String {
      return ChangeSite.getNextChangeText(pumpSiteManager)
    }
    
    public func getCountdownText() -> String {
      return ChangeSite.getCountdownText(pumpSiteManager)
    }

    
}
