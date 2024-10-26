//
//  ReminderNotification.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 10/6/20.
//  Copyright © 2020 Emily Mittleman. All rights reserved.
//

import Foundation

enum ReminderType: Int, Codable, CaseIterable {
  case oneDayBefore = -1, dayOf, oneDayAfter, twoDaysAfter, extendedDaysAfter
}

enum ReminderFrequency: String, Codable {
  case none, single, repeating
}

class Reminder: Codable {
  var type: ReminderType           // "oneDayBefore", "dayOf", "oneDayAfter", etc.
  var frequency: ReminderFrequency  // "none", "single", "repeating"
  var soundOn: Bool
  var repeatingFrequency: Date     // Date object: 5 minutes
  var id = UUID().uuidString

  private enum CodingKeys : String, CodingKey {
    case type, frequency, soundOn, repeatingFrequency, id
  }

  init(
    type: ReminderType,
    frequency: ReminderFrequency = .none,
    soundOn: Bool = false,
    repeatingFrequency: Date = Calendar.current.date(bySettingHour:0, minute:5, second:0, of:.now)!
  ) {
    self.type = type
    self.frequency = frequency
    self.soundOn = soundOn
    self.repeatingFrequency = repeatingFrequency
  }

  required init(from decoder:Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    type = try values.decode(ReminderType.self, forKey: .type)
    frequency = try values.decode(ReminderFrequency.self, forKey: .frequency)
    soundOn = try values.decode(Bool.self, forKey: .soundOn)
    repeatingFrequency = try values.decode(Date.self, forKey: .repeatingFrequency)
    id = try values.decode(String.self, forKey: .id)
  }
}
