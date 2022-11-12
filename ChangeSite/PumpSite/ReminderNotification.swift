//
//  ReminderNotification.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 10/6/20.
//  Copyright © 2020 Emily Mittleman. All rights reserved.
//

import Foundation
import ARKit

enum ReminderOccurrence: String {
    case none, single, repeating
}

enum ReminderType: Int {
    case oneDayBefore = -1, dayOf, oneDayAfter, twoDaysAfter, extendedDaysAfter
}

class ReminderNotification: Codable {
    // TODO: refactor type as enum
    var type: String        // "oneDayBefore", "dayOf", "oneDayAfter", etc.
    // TODO: refactor occurrence as enum
    var occurrence: String  // "none", "single", "repeating"
    var soundOn: Bool       // true, false
    var frequency: Date     // Date object: 5 minutes
    var id = UUID().uuidString
    var description: String {
        return "Type: \(type), Occurrence: \(occurrence), Sound: \(soundOn)"
    }
    
    init(type: String, occurrence: String = "none", soundOn: Bool = false, frequency: Date = Calendar.current.date(bySettingHour:0, minute:5, second:0, of:Date())!) {
        self.type = type
        self.occurrence = occurrence
        self.soundOn = soundOn
        self.frequency = frequency
    }
}
