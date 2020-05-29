//
//  Objects.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/12/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

struct Reminder : Codable {
    var startDate : Date
    var daysBtwn : Int
    var endDate : Date {
        /* var dateComponent = DateComponents()
        dateComponent.day = daysBtwn
        let d = Calendar.current.date(byAdding: dateComponent, to: startDate)!
        return d */
        // this could be problematic -> d.addTimeInterval() might also change startDate
        var d = startDate
        d.addTimeInterval(TimeInterval(daysBtwn * 60 * 60 * 24))
        return d
    }
    var overdue : Bool {
        return endDate < Date() //the endDate is earlier than the current date
    }
}

struct ReminderNotification : Codable {
    var occurrence: String
    var soundOn: Bool
    var frequency: Date //change to Double or Date?
}

struct ReminderNotificationPressed : Codable {
    var name: String
}

extension UIColor {
    class var teal: UIColor {
        return UIColor(red: 0, green: 204/255.0, blue: 204/255.0, alpha: 1.0)
    }
    
    class var customGreen: UIColor {
        let darkGreen = 0x008110
        return UIColor.rgb(fromHex: darkGreen)
    }

    class func rgb(fromHex: Int) -> UIColor {
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension Date {

    func offsetFrom(date : Date) -> String {

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);

        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours

        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
}

/*
struct ReminderNotifications : Codable {
    var notification1 : ReminderNotification
}
*/

/*
class Reminder1 {
    static var startDate: Date {
        set (startDate) {
            UserDefaults.standard.set(startDate, forKey: "startDate")
        }
        get {
            return UserDefaults.standard.object(forKey: "startDate") as! Date
        }
    }
    
    static var daysBtwn: Int {
        set (daysBtwn) {
            UserDefaults.standard.set(daysBtwn, forKey: "daysBtwn")
        }
        get {
            return UserDefaults.standard.integer(forKey: "daysBtwn")
        }
    }
    
    static var endDate: Date {
        set { //pretty much just updates the endDate
            var dateComponent = DateComponents()
            dateComponent.day = daysBtwn
            let d = Calendar.current.date(byAdding: dateComponent, to: startDate)!
            UserDefaults.standard.set(d, forKey: "endDate")
        }
        get {
            return UserDefaults.standard.object(forKey: "endDate") as! Date
        }
    }
}
*/

/*
class ReminderNotification {
    static var occurrence: String {
        // either none, single, or repeating
        set (occurrence) {
            UserDefaults.standard.set(occurrence, forKey: "occurrence")
        }
        get {
            return UserDefaults.standard.string(forKey: "occurrence")!
        }
    }
    
    static var soundOn: Bool {
        set (soundOn) {
            UserDefaults.standard.set(soundOn, forKey: "soundOn")
        }
        get {
            return UserDefaults.standard.bool(forKey: "soundOn")
        }
    }
    
    static var frequency: Double {
        // how many hours & minutes you want a reminder
        set (frequency) {
            UserDefaults.standard.set(frequency, forKey: "frequency")
        }
        get {
            return UserDefaults.standard.double(forKey: "frequency")
        }
    }
    
}
*/



// Date().timeIntervalSince1970
