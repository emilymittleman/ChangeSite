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
  private(set) var startDate: Date {
    get { storage.retrieveValue(StorageKey.startDate) as? Date ?? defaultStartDate }
    set { storage.storeValue(formatDate(newValue) as NSDate, forKey: StorageKey.startDate) }
  }
  private(set) var daysBtwn: Int {
    get { storage.retrieveValue(StorageKey.daysBetween) as? Int ?? defaultDaysBtwn }
    set { storage.storeValue(newValue as NSInteger, forKey: StorageKey.daysBetween) }
  }
  public var endDate: Date { get { Date(timeInterval: TimeInterval(daysBtwn * AppConstants.secondsPerDay), since: self.startDate) } }
  public var overdue: Bool { get { self.endDate < .now } }

  public func getPumpSite() -> PumpSite {
    return PumpSite(startDate: startDate, daysBtwn: daysBtwn)
  }

  // MARK: Mutators

  public func updatePumpSite(daysBtwnChanges: Int) {
    if daysBtwnChanges >= 1 {
      self.daysBtwn = daysBtwnChanges
    }
  }

  public func updatePumpSite(startDate: Date) {
    // Database compliance: allows new user with default pumpSite to set up startDate since newStartDate must be > oldStartDate
    if AppConfig.isNewUser() || startDate > self.startDate || true {
      self.startDate = startDate
    }
  }

  public func updatePumpSite(changeTime: Date) {
    let hours = Calendar.current.component(.hour, from: changeTime)
    let minutes = Calendar.current.component(.minute, from: changeTime)
    if let newStartDate = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: self.endDate) {
      self.startDate = newStartDate
    }
  }
}
