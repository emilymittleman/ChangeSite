//
//  TabItem.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/12/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

enum TabItem: String, CaseIterable {
    case home = "home"
    case calendar = "calendar"
    case settings = "settings"
    
    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController.viewController()
        case .calendar:
            return HomeVC() // TODO: implement CalendarVC
        case .settings:
            let navController = UINavigationController()
            let settingsVC = SettingsTableViewController.viewController()
            navController.viewControllers = [settingsVC]
            return navController
        }
    }
    
    var icon: UIImage {
        switch self {
        case .home:
            return UIImage(named: "Home")! //TODO: add icons
        case .calendar:
            return UIImage(named: "Calendar")!
            //return UIImage(named: "Rectangle")!
        case .settings:
            return UIImage(named: "Settings")!
        }
    }
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
