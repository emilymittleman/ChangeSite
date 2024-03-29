//
//  PumpSiteUtils.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 1/23/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import Foundation

public let dateFormatter = DateFormatter()
public func dateFormatter(_ format: String = "EEEE") -> DateFormatter {
  dateFormatter.dateFormat = format
  return dateFormatter
}

public func getNextChangeText(_ pumpSiteManager: PumpSiteManager) -> String {
  var nextChangeString = pumpSiteManager.overdue ? "Change was due " : "Change is due "
  nextChangeString += getWeekday(from: pumpSiteManager.endDate)
  return nextChangeString
}

public func getWeekday(from date: Date) -> String {
  if Calendar.current.isDate(date, inSameDayAs: Date()) {
    return "today"
  }
  return dateFormatter("EEEE").string(from: date).capitalized
}

//public func getDay(from date: Date) 

public func getCountdownText(_ pumpSiteManager: PumpSiteManager) -> String {
  let days = daysBetweenDates(from: Date(), to: pumpSiteManager.endDate)
  let diff = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: pumpSiteManager.endDate)
  let hours = abs(diff.hour ?? 0)
  let minutes = abs(diff.minute ?? 0)

  return makeCountdownText(
    isOverdue: pumpSiteManager.overdue,
    time: days == 0 ? hours == 0 ? minutes : hours : days,
    timeUnit: days == 0
      ? hours == 0
        ? "Minute"
        : "Hour"
      : "Day"
  )
}

// MARK: Helper functions

private func makeCountdownText(isOverdue: Bool, time: Int, timeUnit: String) -> String {
  var text = String(time) + " " + timeUnit
  if time != 1 { text += "s" } //make timeUnit plural
  if isOverdue {
    text += " Late"
    text = text.capitalized
  } else {
    text += " Left"
  }
  return text
}
