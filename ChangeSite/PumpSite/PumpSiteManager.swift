//
//  ReminderManager.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 7/16/20.
//  Copyright © 2020 Emily Mittleman. All rights reserved.
//

import Foundation

public class PumpSiteManager {
  private var pumpSite: PumpSite!;
  private let storage = UserDefaultsAccessHelper.sharedInstance
  public var startDate: Date { get { return pumpSite.startDate } }
  public var daysBtwn: Int { get { return pumpSite.daysBtwn } }
  public var endDate: Date { get { return pumpSite.endDate } }
  public var overdue: Bool { get { return pumpSite.overdue } }

  public init() {
    self.storage.setUp(withGroupID: Bundle.main.appGroupID)
    self.retrieveFromStorage()
  }

  public init(startDate: Date, daysBtwn: Int) {
    self.storage.setUp(withGroupID: Bundle.main.appGroupID)
    self.pumpSite = PumpSite(startDate: startDate, daysBtwn: daysBtwn)
    self.saveToStorage()
  }

  private func retrieveFromStorage() {
    if let pumpSiteData = storage.retrieveValue(UserDefaults.Keys.pumpSite.rawValue),
       let pumpSite = try? PropertyListDecoder().decode(PumpSite.self, from: pumpSiteData as! Data) {
      self.pumpSite = pumpSite
    } else {
      self.setDefaultValues()
    }
  }

  private func saveToStorage() {
    storage.storeValue(try? PropertyListEncoder().encode(pumpSite), withIdentifier: UserDefaults.Keys.pumpSite.rawValue)
  }

  private func setDefaultValues() {
    // Database compliance: allows new user with default pumpSite to set up startDate since newStartDate must be > oldStartDate
    let newUser = (storage.retrieveValue(UserDefaults.Keys.newUser.rawValue) as? Bool) ?? true
    let date = newUser ? Date(timeIntervalSince1970: 0) : Date()
    let startingDate = formatDate(date)
    self.pumpSite = PumpSite(startDate: startingDate, daysBtwn: 4)
    self.saveToStorage()
  }

  // MARK: Mutators
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
}

class PumpSite: Codable {
  private(set) var startDate: Date
  private(set) var daysBtwn: Int
  private(set) var endDate: Date
  var overdue: Bool { get { return self.endDate < Date() } }

  init(startDate: Date, daysBtwn: Int) {
    self.startDate = startDate
    self.daysBtwn = daysBtwn
    self.endDate = startDate
    self.endDate.addTimeInterval(TimeInterval(daysBtwn * AppConstants.secondsPerDay))
  }

  func setStartDate(startDate: Date) {
    self.startDate = startDate
    self.endDate = startDate
    self.endDate.addTimeInterval(TimeInterval(daysBtwn * AppConstants.secondsPerDay))
  }

  func setDaysBtwn(daysBtwn: Int) {
    self.daysBtwn = daysBtwn
    self.endDate = startDate
    self.endDate.addTimeInterval(TimeInterval(daysBtwn * AppConstants.secondsPerDay))
  }
}

