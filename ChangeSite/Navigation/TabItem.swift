//
//  TabItem.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/12/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

enum TabItem {
  case home(pumpSiteManager: PumpSiteManager, remindersManager: RemindersManager)
  case calendar(pumpSiteManager: PumpSiteManager)
  case settings(pumpSiteManager: PumpSiteManager, remindersManager: RemindersManager)

  var viewController: UIViewController {
    switch self {
    case .home(let pumpSiteManager, let remindersManager):
      return HomeViewController.viewController(pumpSiteManager: pumpSiteManager, remindersManager: remindersManager)
    case .calendar(let pumpSiteManager):
      return CalendarViewController.viewController(pumpSiteManager: pumpSiteManager)
    case .settings(let pumpSiteManager, let remindersManager):
      let navController = UINavigationController()
      let settingsVC = SettingsTableViewController.viewController(pumpSiteManager: pumpSiteManager, remindersManager: remindersManager)
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
