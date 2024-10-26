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
  #if DEBUG
  case debug(pumpSiteManager: PumpSiteManager, remindersManager: RemindersManager)
  #endif

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
    #if DEBUG
    case .debug(let pumpSiteManager, let remindersManager):
      return DebugViewController()
    #endif
    }
  }
  
  var icon: UIImage {
    switch self {
    case .home:
      return UIImage(named: "Home") ?? UIImage(resource: .home)
    case .calendar:
      return UIImage(named: "Calendar") ?? UIImage(resource: .calendar)
    case .settings:
      return UIImage(named: "Settings") ?? UIImage(resource: .settings)
    #if DEBUG
    case .debug:
      return UIImage(named: "Code") ?? UIImage(resource: .logoCircle)
    #endif
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
    #if DEBUG
    case .debug:
      return "Debug"
    #endif
    }
  }
}
