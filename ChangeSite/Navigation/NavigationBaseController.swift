//
//  NavigationBaseController.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/12/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

class NavigationMenuBaseController: UITabBarController, InjectsPumpData {
    
    var pumpSiteManager: PumpSiteManager!
    var remindersManager: RemindersManager!
    
    var customTabBar: TabNavigationMenu!
    var tabBarHeight: CGFloat = 83.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
    }
    
    private func loadTabBar() {
        let tabItems: [TabItem] = [
            .home(pumpSiteManager: pumpSiteManager, remindersManager: remindersManager),
            .calendar(pumpSiteManager: pumpSiteManager),
            .settings(pumpSiteManager: pumpSiteManager, remindersManager: remindersManager)
        ]
        self.setupCustomTabBar(tabItems) { (controllers) in
            self.viewControllers = controllers
        }
        self.selectedIndex = 0 // default our selected index to the first item
    }
    
    func setupCustomTabBar(_ items: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        // handle creation of the tab bar and attach touch event listeners
        let frame = CGRect(x: tabBar.frame.origin.x,
                           y: tabBar.frame.origin.x,
                           width: tabBar.frame.width,
                           height: tabBarHeight)
        self.customTabBar = TabNavigationMenu(menuItems: items, frame: frame)
        self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.customTabBar.clipsToBounds = true
        self.customTabBar.itemTapped = self.changeTab
        self.customTabBar.addTopBorder(with: UIColor.lightGray, andWidth: 1)
        self.view.addSubview(customTabBar)
        
        // Add positioning constraints to place the nav menu right where the tab bar should be
        NSLayoutConstraint.activate([
            self.customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            self.customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            self.customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            self.customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight), // Fixed height for nav menu
            self.customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
        
        var controllers = [UIViewController]()
        for i in 0 ..< items.count {
            controllers.append(items[i].viewController) // we fetch the matching view controller and append here
        }
        
        self.view.layoutIfNeeded() // important step
        completion(controllers) // setup complete. handoff here
    }
    
    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
}
