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
    get { storage.date(for: .startDate) ?? defaultStartDate }
    set { storage.set(formatDate(newValue), forKey: .startDate) }
  }
  private(set) var daysBtwn: Int {
    get { storage.int(for: .daysBetween) ?? defaultDaysBtwn }
    set { storage.set(newValue, forKey: .daysBetween) }
  }
  public var endDate: Date { get { Date(timeInterval: TimeInterval(daysBtwn * AppConstants.secondsPerDay), since: self.startDate) } }
  public var overdue: Bool { get { self.endDate < .now } }

  public func getPumpSite() -> PumpSite {
    return PumpSite(startDate: startDate, daysBtwn: daysBtwn)
  }

  // MARK: Mutators

  public func setDaysBtwnChanges(_ daysBtwnChanges: Int) {
    if daysBtwnChanges >= 1 {
      self.daysBtwn = daysBtwnChanges
    }
  }

  public func updatePumpSite(startDate: Date) {
    var isDebug = false
    #if DEBUG
    isDebug = true
    #endif
    // Database compliance: allows new user with default pumpSite to set up startDate since newStartDate must be > oldStartDate
    if storage.isNewUser() || startDate > self.startDate || isDebug {
      self.startDate = startDate
    }
  }

  public func setDefaultChangeTimme(_ changeTime: Date) {
    let hours = Calendar.current.component(.hour, from: changeTime)
    let minutes = Calendar.current.component(.minute, from: changeTime)
    if let newStartDate = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: self.startDate) {
      self.startDate = newStartDate
    }
  }
}
