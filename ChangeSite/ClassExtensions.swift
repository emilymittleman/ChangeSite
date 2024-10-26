//
//  Objects.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/12/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public extension Bundle {
  var appGroupID: String {
    "group.com.EmilyMittleman.ChangeSite"
  }
}

enum AppConstants {
  static let secondsPerDay = 60 * 60 * 24
  static let tabBarHeight: CGFloat = 83.0
}

// MARK: Public helper functions

public func daysBetweenDates(from date1: Date, to date2: Date) -> Int {
  let dateFrom = Calendar.current.startOfDay(for: date1)
  let dateTo = Calendar.current.startOfDay(for: date2)
  return abs(Calendar.current.dateComponents([.day], from: dateFrom, to: dateTo).day ?? 0)
}

public func signedDaysBetweenDates(from date1: Date, to date2: Date) -> Int {
  let dateFrom = Calendar.current.startOfDay(for: date1)
  let dateTo = Calendar.current.startOfDay(for: date2)
  return Calendar.current.dateComponents([.day], from: dateFrom, to: dateTo).day ?? 0
}

public func formatCoreDataDate(_ date: Date) -> Date {
  return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date) ?? date
}

public func formatDate(_ date: Date) -> Date {
  let hours = Calendar.current.component(.hour, from: date)
  let minutes = Calendar.current.component(.minute, from: date)
  let minutesHalf = Int(floor(Double(minutes)/30.0) * 30) % 60
  return Calendar.current.date(bySettingHour: hours, minute: minutesHalf, second: 0, of: date)!
}

// MARK: Date

extension Date {
  func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
    return calendar.dateComponents(Set(components), from: self)
  }

  func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
    return calendar.component(component, from: self)
  }
}
