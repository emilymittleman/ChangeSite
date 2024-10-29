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
  var expiration: Date { get { Date(timeInterval: TimeInterval(daysBtwn * AppConstants.secondsPerDay), since: startDate) } }
  var overdue: Bool { get { expiration < .now } }

  init(startDate: Date = .now, daysBtwn: Int = 3) {
    self.startDate = formatDate(startDate)
    self.daysBtwn = daysBtwn
  }
}
