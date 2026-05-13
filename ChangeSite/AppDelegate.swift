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
import SwiftUI
import Combine

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
  var appState: AppState?
  private var appStateCancellable: AnyCancellable?

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

    #if DEBUG
    if ProcessInfo.processInfo.arguments.contains("-skipSetup") {
      if UserDefaultsAccessHelper.sharedInstance.isNewUser() {
        pumpSiteManager!.setStartDate(Date())
        pumpSiteManager!.setDaysBtwnChanges(3)
        UserDefaultsAccessHelper.sharedInstance.setUserFinishedSetup()
      }
    }
    if ProcessInfo.processInfo.arguments.contains("-resetUser") {
      UserDefaultsAccessHelper.sharedInstance.clearAllData()
      SiteDatesProvider(with: coreDataStack.managedContext).deleteAllEntries()
    }
    #endif

    let isNewUser = UserDefaultsAccessHelper.sharedInstance.isNewUser()
    if isNewUser {
      // SwiftUI onboarding flow — LaunchView → SetupView
      let state = AppState(isNewUser: true)
      self.appState = state

      let launchView = LaunchView()
        .environmentObject(pumpSiteManager!)
        .environmentObject(remindersManager!)
        .environmentObject(state)

      initialViewController = UIHostingController(rootView: launchView)

      // Observe the flag: when SetupView calls appState.isNewUser = false,
      // swap the root VC to the main tab bar on the main thread.
      appStateCancellable = state.$isNewUser
        .dropFirst() // ignore the initial true
        .filter { !$0 }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
          self?.presentMainTabBar()
        }
    } else if let vc = storyboard.instantiateViewController(withIdentifier: "navigationMenuBaseController") as? NavigationMenuBaseController {
      vc.pumpSiteManager = pumpSiteManager
      vc.remindersManager = remindersManager
      initialViewController = vc
    }
    self.window?.rootViewController = initialViewController
    self.window?.makeKeyAndVisible()
  }

  /// Swaps the window root to the UIKit tab bar after onboarding completes.
  private func presentMainTabBar() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let vc = storyboard.instantiateViewController(withIdentifier: "navigationMenuBaseController") as? NavigationMenuBaseController else {
      return
    }
    vc.pumpSiteManager = pumpSiteManager
    vc.remindersManager = remindersManager

    // Animate the root swap so the transition doesn't flash.
    UIView.transition(
      with: window!,
      duration: 0.35,
      options: .transitionCrossDissolve,
      animations: { self.window?.rootViewController = vc },
      completion: { _ in self.appStateCancellable = nil }
    )
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
    // Special case: If user turned off notifications, need to reset reminders
    /*if !notificationManager.notificationsEnabled() {
     for reminderNotification in reminderNotifications {
     if reminderNotification.frequency != .none {
     reminderNotification.frequency = .none
     ReminderNotificationsManager.shared.mutateNotification(newReminderNotif: reminderNotification)
     notificationManager.removeAllNotifications()
     }
     }
     }*/
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
