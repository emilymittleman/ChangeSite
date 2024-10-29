//
//  ReminderManager.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 7/16/20.
//  Copyright © 2020 Emily Mittleman. All rights reserved.
//

import Foundation

let defaultStartDate = Date.now
let defaultDaysBtwn = 3

public class PumpSiteManager {
  private let storage = UserDefaultsAccessHelper.sharedInstance
  #if !BUILDING_FOR_EXTENSION
  private let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
  #endif

  private(set) var startDate: Date {
    get { storage.date(for: .startDate) ?? defaultStartDate }
    set { storage.set(formatDate(newValue), forKey: .startDate) }
  }
  private(set) var daysBtwn: Int {
    get { storage.int(for: .daysBetween) ?? defaultDaysBtwn }
    set { storage.set(newValue, forKey: .daysBetween) }
  }
  public var endDate: Date { get { Date(timeInterval: TimeInterval(daysBtwn * AppConstants.secondsPerDay), since: startDate) } }
  public var overdue: Bool { get { endDate < .now } }

  public func getPumpSite() -> PumpSite {
    return PumpSite(startDate: startDate, daysBtwn: daysBtwn)
  }

  // MARK: Mutators

  // TODO: Support editing start date
  public func setStartDate(_ date: Date) {
    // Need to update CoreData
    self.startDate = date
    #if !BUILDING_FOR_EXTENSION
    SiteDates.createOrUpdate(pumpSite: getPumpSite(), endDate: nil, with: coreDataStack)
    coreDataStack.saveContext()
    #endif
    NotificationManager.shared.rescheduleNotifications()
  }

  public func setDaysBtwnChanges(_ daysBtwnChanges: Int) {
    guard daysBtwnChanges >= 1 else {
      return
    }
    self.daysBtwn = daysBtwnChanges
    #if !BUILDING_FOR_EXTENSION
    SiteDates.createOrUpdate(pumpSite: getPumpSite(), endDate: nil, with: coreDataStack)
    coreDataStack.saveContext()
    #endif
    NotificationManager.shared.rescheduleNotifications()
  }

  public func changedSite(changeDate: Date) {
    // Database compliance: allows new user with default pumpSite to set up startDate since newStartDate must be > oldStartDate
    guard storage.isNewUser() || changeDate > self.startDate || Bundle.main.isDebug else {
      return
    }
    #if !BUILDING_FOR_EXTENSION
    // End current site
    SiteDates.createOrUpdate(pumpSite: getPumpSite(), endDate: changeDate, with: coreDataStack)
    coreDataStack.saveContext()
    #endif

    setStartDate(changeDate)
  }

  public func setDefaultChangeTimme(_ changeTime: Date) {
    storage.set(changeTime, forKey: .defaultChangeTime)

    let hours = Calendar.current.component(.hour, from: changeTime)
    let minutes = Calendar.current.component(.minute, from: changeTime)
    if let newStartDate = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: self.startDate) {
      setStartDate(newStartDate)
    }
  }
}
