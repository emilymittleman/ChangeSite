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
    
    // Remove all pending and delivered notifications
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func removeScheduledNotification(reminder: ReminderNotification) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id])
    }
    
    func scheduleNotification(reminder: ReminderNotification, pumpExiredDate: Date) {
        // TODO: figure out repeating notifications (maybe make loop to add a bunch of new triggerDates each 5 min after triggerDate extending up to 24 hours) https://codecrew.codewithchris.com/t/repeating-notifications/17441/2
        if reminder.occurrence == ReminderOccurrence.none.rawValue { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Change Your Pump Site"
        content.sound = reminder.soundOn ? UNNotificationSound.default : nil
        
        // let daysBtwnReminderAndExpire = reminder.type.rawValue
        var daysBtwnReminderAndExpire = 0
        switch reminder.type {
        case "oneDayBefore":
            daysBtwnReminderAndExpire = -1
            content.title = "Change Your Pump Site Soon"
            content.body = "Pump site will expire tomorrow!"
        case "dayOf":
            daysBtwnReminderAndExpire = 0
            content.body = "Pump site expired, change it now!"
        case "oneDayAfter":
            daysBtwnReminderAndExpire = 1
            content.body = "Pump site expired 1 day ago, change it now!"
        case "twoDaysAfter":
            daysBtwnReminderAndExpire = 2
            content.body = "Pump site expired 2 days ago, change it now!"
        case "extendedDaysAfter":
            daysBtwnReminderAndExpire = 3 //figure this case out
            content.body = "Pump site expired 3 days ago, change it now!" //figure out
        default:
            daysBtwnReminderAndExpire = 0
        }
        //content.body = "Pump site expired \(daysBtwnReminderAndExpire) days ago, change it now!"
        
        var triggerDate = pumpExiredDate
        triggerDate.addTimeInterval(TimeInterval(daysBtwnReminderAndExpire * 60 * 60 * 24))
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: triggerDate),
            repeats: false)
        
        let request = UNNotificationRequest(identifier: reminder.id,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print(error) }
        }
    }
}

