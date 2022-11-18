//
//  SettingsViewModel.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/17/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation

enum SettingsSection: Int {
    case General, Reminders, Count

    static var count = {
        return SettingsSection.Count.rawValue
    }

    static let sectionTitles = [General: "",
                              Reminders: "Reminder Notifications"]

    func sectionTitle() -> String {
        if let sectionTitle = SettingsSection.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }
}

class SettingsViewModel {
    
    let pumpSite: PumpSite
    let reminders: [ReminderNotification]
    
    init(pumpSite: PumpSite, reminders: [ReminderNotification]) {
        self.pumpSite = pumpSite
        self.reminders = reminders
    }
}

