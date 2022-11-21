//
//  NotificationManager.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/10/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation
import UIKit

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    struct Config {
        var pumpSiteManager: PumpSiteManager
        var remindersManager: RemindersManager
    }
    private static var config: Config?
    private let pumpSiteManager: PumpSiteManager
    private let remindersManager: RemindersManager
    @Published var settings: UNNotificationSettings?
    
    class func setup(_ config: Config) {
        NotificationManager.config = config
    }
    private init() {
        guard let config = NotificationManager.config else {
            fatalError("Error - you must call setup before accessing NotificationManager.shared")
        }
        pumpSiteManager = config.pumpSiteManager
        remindersManager = config.remindersManager
    }
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            self?.fetchNotificationSettings()
            completion(granted)
        }
    }
    
    func fetchNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    func notificationsEnabled() -> Bool {
        guard let settings = self.settings else {
            return false
        }
        return settings.authorizationStatus == UNAuthorizationStatus.authorized
    }
    
    // Async version is for HomeScreen, since this is the only place settings might not be loaded yet
    // might not need this since fetchNotificationSettings is in appDelegate now; test later
    func notificationsEnabled(completion: @escaping (Bool) -> () ) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus == UNAuthorizationStatus.authorized)
        }
    }
    
    // Remove all pending and delivered notifications
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func removeScheduledNotification(reminderType: ReminderType) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [remindersManager.getID(type: reminderType)])
    }
    
    func scheduleNotifications(reminderTypes: [ReminderType]) {
        for type in reminderTypes {
            scheduleNotification(reminderType: type)
        }
    }
    
    func scheduleNotification(reminderType: ReminderType) {
        // TODO: figure out repeating notifications (maybe make loop to add a bunch of new triggerDates each 5 min after triggerDate extending up to 24 hours) https://codecrew.codewithchris.com/t/repeating-notifications/17441/2
        let frequency = remindersManager.getFrequency(type: reminderType)
        if frequency == .none { return }
        
        let content = getNotificationContent(reminderType: reminderType, soundOn: remindersManager.getSoundOn(type: reminderType))
        
        // (Test commented out):
        //      var triggerDate = Date()
        //      triggerDate.addTimeInterval(TimeInterval(15 + (reminderType.rawValue * 10))) //5, 15, 25, 35
        var triggerDate = pumpSiteManager.endDate
        triggerDate.addTimeInterval(TimeInterval(reminderType.rawValue * AppConstants.kSecondsPerDay))
        let timeInterval = triggerDate.timeIntervalSinceNow
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false)
        /*let df = DateFormatter()
         df.dateStyle = .full
         df.timeStyle = .full
         print(df.string(from: triggerDate))*/
        let request = UNNotificationRequest(identifier: remindersManager.getID(type: reminderType),
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print(error) }
        }
    }
    
    private func getNotificationContent(reminderType: ReminderType, soundOn: Bool) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.badge = reminderType.rawValue as NSNumber
        content.sound = soundOn ? UNNotificationSound.default : nil
        content.title = "Change your pump site!"
        switch reminderType {
        case .oneDayBefore:
            content.title = "Upcoming pump site change"
            content.body = "Pump site will expire tomorrow!"
        case .dayOf:
            content.body = "Pump site expired today, replace it now"
        case .oneDayAfter:
            content.body = "Pump site expired 1 day ago, replace it now"
        case .twoDaysAfter:
            content.body = "Pump site expired 2 days ago, replace it now"
        case .extendedDaysAfter:
            content.body = "Pump site expired 3 days ago, replace it now" //figure out with repeating
        }
        return content
        
    }
}

