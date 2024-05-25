//
//  PumpSite.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/25/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import Foundation

public class PumpSite: Codable {
  private(set) var startDate: Date
  private(set) var daysBtwn: Int
  private(set) var endDate: Date
  var overdue: Bool { get { return self.endDate < .now } }
  
  init(startDate: Date = .now, daysBtwn: Int = 3) {
    self.startDate = formatDate(startDate)
    self.daysBtwn = daysBtwn
    self.endDate = self.startDate
    self.endDate.addTimeInterval(TimeInterval(daysBtwn * AppConstants.secondsPerDay))
  }
  
  func setStartDate(startDate: Date) {
    self.startDate = formatDate(startDate)
    self.endDate = self.startDate
    self.endDate.addTimeInterval(TimeInterval(daysBtwn * AppConstants.secondsPerDay))
  }
  
  func setDaysBtwn(daysBtwn: Int) {
    self.daysBtwn = daysBtwn
    self.endDate = startDate
    self.endDate.addTimeInterval(TimeInterval(daysBtwn * AppConstants.secondsPerDay))
  }
}
