//
//  TabItem.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/12/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

//enum TabItem: CaseIterable {
enum TabItem {
    case home(pumpSiteManager: PumpSiteManager, remindersManager: ReminderNotificationsManager)
    case calendar(pumpSiteManager: PumpSiteManager)
    case settings(pumpSiteManager: PumpSiteManager, remindersManager: ReminderNotificationsManager)
    
    var viewController: UIViewController {
        switch self {
        case .home(let pumpSiteManager, let remindersManager):
            return HomeViewController.viewController(pumpSiteManager: pumpSiteManager, reminders: remindersManager.reminderNotifications)
        case .calendar(let pumpSiteManager):
            return CalendarViewController.viewController(pumpSiteManager: pumpSiteManager)
        case .settings(let pumpSiteManager, let remindersManager):
            let navController = UINavigationController()
            let settingsVC = SettingsTableViewController.viewController(pumpSiteManager: pumpSiteManager, reminders: remindersManager.reminderNotifications)
            navController.viewControllers = [settingsVC]
            return navController
        }
    }
    
    var icon: UIImage {
        switch self {
        case .home:
            return UIImage(named: "Home")!
        case .calendar:
            return UIImage(named: "Calendar")!
        case .settings:
            return UIImage(named: "Settings")!
        }
    }
    
    var displayTitle: String {
        switch self {
        case .home:
            return "Home"
        case .calendar:
            return "Calendar"
        case .settings:
            return "Settings"
        }
    }
}
