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

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    @Published var settings: UNNotificationSettings?
    
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
    
    func removeScheduledNotification(reminder: ReminderNotification) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id])
    }
    
    func scheduleNotifications(reminders: [ReminderNotification], pumpExiredDate: Date) {
        for reminder in reminders {
            scheduleNotification(reminder: reminder, pumpExiredDate: pumpExiredDate)
        }
    }
    
    func scheduleNotification(reminder: ReminderNotification, pumpExiredDate: Date) {
        // TODO: figure out repeating notifications (maybe make loop to add a bunch of new triggerDates each 5 min after triggerDate extending up to 24 hours) https://codecrew.codewithchris.com/t/repeating-notifications/17441/2
        if reminder.frequency == ReminderFrequency.none { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Change Your Pump Site"
        content.sound = reminder.soundOn ? UNNotificationSound.default : nil
        
        let daysBtwnReminderAndExpire = reminder.type.rawValue
        
        switch reminder.type {
        case .oneDayBefore:
            content.title = "Change Your Pump Site Soon"
            content.body = "Pump site will expire tomorrow!"
        case .dayOf:
            content.body = "Pump site expired, change it now!"
        case .oneDayAfter:
            content.body = "Pump site expired 1 day ago, change it now!"
        case .twoDaysAfter:
            content.body = "Pump site expired 2 days ago, change it now!"
        case .extendedDaysAfter:
            content.body = "Pump site expired 3 days ago, change it now!" //figure out
        }
        //content.body = "Pump site expired \(daysBtwnReminderAndExpire) days ago, change it now!"
        
        var triggerDate = pumpExiredDate
        triggerDate.addTimeInterval(TimeInterval(daysBtwnReminderAndExpire * 60 * 60 * 24))
        
        /*let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: triggerDate),
            repeats: false)*/
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10,
            repeats: false)
        
        let request = UNNotificationRequest(identifier: reminder.id,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print(error) }
        }
    }
}

