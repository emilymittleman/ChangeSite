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

  public func startNewPumpSite(changeDate: Date) {
    // End current site
    SiteDates.createOrUpdate(pumpSiteManager: pumpSiteManager, endDate: changeDate, with: coreDataStack)
    coreDataStack.saveContext()
    // Start new site
    pumpSiteManager.updatePumpSite(startDate: changeDate)
    SiteDates.createOrUpdate(pumpSiteManager: pumpSiteManager, endDate: nil, with: coreDataStack)
    coreDataStack.saveContext()
    notificationManager.rescheduleNotifications()
  }

  public func updateCoreData() {
    // if current site is overdue AND coredata.overdue != current overdue days, update CoreData
    guard let currentSite = siteDatesProvider.getCurrentSite() else {
      print("Database error: could not retrieve current site")
      return
    }

    // check daysOverdue (daysOverdue & expiredDate will be updated if daysBtwn changed)
    if pumpSiteManager.overdue {
      let daysOver = signedDaysBetweenDates(from: pumpSiteManager.endDate, to: .now)
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
    return ChangeSite.getCountdownText(pumpSiteManager.getPumpSite())
  }

}
