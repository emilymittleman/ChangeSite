//
//  AppDelegate.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit
import UserNotifications

enum Identifiers {
  static let newSiteAction = "NEW_SITE_IDENTIFIER"
  static let newSiteCategory = "NEW_SITE_CATEGORY"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications(application: application)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let newUser = UserDefaults.standard.bool(forKey: "newUser")
        if !newUser {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(PumpSiteManager.shared.pumpSite), forKey: "pumpSite")
            UserDefaults.standard.set(try? PropertyListEncoder().encode(ReminderNotificationsManager.shared.reminderNotifications), forKey: "reminderNotifications")
        } else {
            UserDefaults.standard.removeObject(forKey: "pumpSite")
            UserDefaults.standard.removeObject(forKey: "reminderNotification")
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            // Make custom actions on notifications
            let newSiteAction = UNNotificationAction(
              identifier: Identifiers.newSiteAction,
              title: "New site started",
              options: [.foreground])
            let newSiteCategory = UNNotificationCategory(
              identifier: Identifiers.newSiteCategory,
              actions: [newSiteAction],
              intentIdentifiers: [],
              options: [])
            UNUserNotificationCenter.current().setNotificationCategories([newSiteCategory])
            self?.getNotificationSettings()
            /*DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }*/
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        // set a flag and try to register again in the future
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == Identifiers.newSiteAction {
            // TODO: User reset pump site, so handle accordingly (assume they changed it when they tapped the notification)
        }
        
        completionHandler()
    }
}


