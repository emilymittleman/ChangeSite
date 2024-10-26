//
//  AppDelegate.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import WidgetKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Core Data Saving support
  lazy var coreDataStack: CoreDataStack = .init(modelName: "PumpSite")

  static let sharedAppDelegate: AppDelegate = {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
    }
    return delegate
  }()

  var window: UIWindow?
  var pumpSiteManager: PumpSiteManager?
  var remindersManager: RemindersManager?
  var notificationManager: NotificationManager?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UserDefaultsAccessHelper.sharedInstance.setUp(withGroupID: Bundle.main.appGroupID)

    UNUserNotificationCenter.current().delegate = self
    // Initialize data managers
    pumpSiteManager = PumpSiteManager()
    remindersManager = RemindersManager()
    NotificationManager.setup(NotificationManager.Config(pumpSiteManager: pumpSiteManager!, remindersManager: remindersManager!))
    presentInitialView()
    return true
  }

  private func presentInitialView() {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var initialViewController: UIViewController = UIViewController()
    let isNewUser = UserDefaultsAccessHelper.sharedInstance.isNewUser()
    if isNewUser, let vc = storyboard.instantiateViewController(withIdentifier: "LaunchScreen") as? LaunchViewController {
      vc.pumpSiteManager = pumpSiteManager
      vc.remindersManager = remindersManager
      initialViewController = vc
    } else if let vc = storyboard.instantiateViewController(withIdentifier: "navigationMenuBaseController") as? NavigationMenuBaseController {
      vc.pumpSiteManager = pumpSiteManager
      vc.remindersManager = remindersManager
      initialViewController = vc
    }
    self.window?.rootViewController = initialViewController
    self.window?.makeKeyAndVisible()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    WidgetCenter.shared.reloadAllTimelines()
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if !UserDefaultsAccessHelper.sharedInstance.isNewUser() {
      AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    } else {
      UserDefaultsAccessHelper.sharedInstance.deleteValue(withKey: StorageKey.startDate)
      UserDefaultsAccessHelper.sharedInstance.deleteValue(withKey: StorageKey.daysBetween)
      UserDefaultsAccessHelper.sharedInstance.deleteValue(withKey: StorageKey.reminders)
    }
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NotificationManager.shared.fetchNotificationSettings()
    UIApplication.shared.applicationIconBadgeNumber = 0
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
      completionHandler(.banner)
  }
}
