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
  var notificationManager = NotificationManager.shared
  var coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
  var siteDatesProvider = SiteDatesProvider(with: AppDelegate.sharedAppDelegate.coreDataStack.managedContext)

  init(pumpSiteManager: PumpSiteManager, remindersManager: RemindersManager) {
    self.pumpSiteManager = pumpSiteManager
    self.remindersManager = remindersManager
  }

  // MARK: Mutators

  public func updatePumpSite(daysBtwnChanges: Int) {
    self.pumpSiteManager.updatePumpSite(daysBtwnChanges: daysBtwnChanges)
    SiteDates.createOrUpdate(pumpSiteManager: pumpSiteManager, endDate: nil, with: coreDataStack)
    coreDataStack.saveContext()
    // Reschedule notifications
    notificationManager.removeAllNotifications()
    notificationManager.scheduleNotifications(reminderTypes: ReminderType.allCases)
  }

  // MARK: Strings

  public func formattedStartDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.timeStyle = DateFormatter.Style.short
    return dateFormatter.string(from: self.pumpSiteManager.startDate)
  }

  public func defaultChangeTime() -> String {
    if let defaultChangeTimeData = UserDefaults.standard.object(forKey: UserDefaults.Keys.defaultChangeTime.rawValue),
       let defaultChangeTime = defaultChangeTimeData as? Date {
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      formatter.dateStyle = .none
      return formatter.string(from: defaultChangeTime)
    }
    return "Off"
  }

  public func reminderFrequencyStrings() -> [String] {
    return ReminderType.allCases.map { remindersManager.getFrequency(type: $0).rawValue }
  }

  public func pumpSiteDaysBtwn() -> Double {
    return Double(self.pumpSiteManager.daysBtwn)
  }

  public func pumpSiteDaysBtwnString() -> String {
    return String(self.pumpSiteManager.daysBtwn)
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
