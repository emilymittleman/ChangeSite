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
    self.pumpSite = PumpSite(startDate: startDate, daysBtwn: daysBtwn)
    self.saveToStorage()
  }
  
  public func getPumpSite() -> PumpSite {
    return PumpSite(startDate: startDate, daysBtwn: daysBtwn)
  }

  private func retrieveFromStorage() {
    if let pumpSiteData = storage.retrieveValue(StorageKey.pumpSite),
       let pumpSite = try? PropertyListDecoder().decode(PumpSite.self, from: pumpSiteData as! Data) {
      self.pumpSite = pumpSite
    } else {
      self.setDefaultValues()
    }
  }

  private func saveToStorage() {
    storage.storeValue(try? PropertyListEncoder().encode(pumpSite), forKey: StorageKey.pumpSite)
  }

  private func setDefaultValues() {
    self.pumpSite = PumpSite(startDate: .now, daysBtwn: 4)
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
    // Database compliance: allows new user with default pumpSite to set up startDate since newStartDate must be > oldStartDate
    if AppConfig.isNewUser() || startDate > pumpSite.startDate {
      self.pumpSite.setStartDate(startDate: startDate)
      self.saveToStorage()
    }
  }
}
