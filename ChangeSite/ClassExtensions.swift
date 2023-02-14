//
//  Objects.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/12/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

enum AppConstants {
    static let secondsPerDay = 60 * 60 * 24
}

// MARK: Storage

extension UserDefaults {
    enum Keys: String {
        // TODO: left off here
        case pumpSite, reminders, newUser, defaultChangeTime
    }
}

// MARK: Public helper functions

public func daysBetweenDates(from date1: Date, to date2: Date) -> Int {
    let dateFrom = Calendar.current.startOfDay(for: date1)
    let dateTo = Calendar.current.startOfDay(for: date2)
    return abs(Calendar.current.dateComponents([.day], from: dateFrom, to: dateTo).day ?? 0)
}

public func signedDaysBetweenDates(from date1: Date, to date2: Date) -> Int {
    let dateFrom = Calendar.current.startOfDay(for: date1)
    let dateTo = Calendar.current.startOfDay(for: date2)
    return Calendar.current.dateComponents([.day], from: dateFrom, to: dateTo).day ?? 0
}

public func formatCoreDataDate(_ date: Date) -> Date {
    return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date) ?? date
}

public func formatDate(_ date: Date) -> Date {
    let hours = Calendar.current.component(.hour, from: date)
    let minutes = Calendar.current.component(.minute, from: date)
    let minutesHalf = Int(floor(Double(minutes)/30.0) * 30) % 60
    return Calendar.current.date(bySettingHour: hours, minute: minutesHalf, second: 0, of: date)!
}

// MARK: Colors

extension UIColor {
    
    // Light mode -> white, Dark mode -> charcoal
    class func background(_ mode: UIUserInterfaceStyle) -> UIColor {
        if mode == .dark {
            return charcoal
        }
        return UIColor.systemBackground.resolvedColor(with: UITraitCollection.init(userInterfaceStyle: .light))
    }
    
    // Light mode -> white, Dark mode -> charcoal
    class func tabBarTint(_ mode: UIUserInterfaceStyle) -> UIColor {
        if mode == .dark {
            return UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        }
        return .clear
    }
    
    // Dark mode returns white
    class func charcoal(_ mode: UIUserInterfaceStyle) -> UIColor {
        if mode == .dark {
            return background(.light)
        }
        return UIColor(red: 63/255.0, green: 63/255.0, blue: 63/255.0, alpha: 1.0)
    }
    
    class var charcoal: UIColor {
        return charcoal(.light)
    }
    
    class var lightBlue: UIColor {
        return UIColor(red: 147/255.0, green: 222/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    class var purpleBlue: UIColor {
        return purpleBlue(.light)
    }
    class func purpleBlue(_ mode: UIUserInterfaceStyle) -> UIColor {
        if mode == .dark {
            return lightGreen
        }
        return UIColor(red: 92/255.0, green: 109/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    class var lightGreen: UIColor {
        return UIColor.rgb(fromHex: 0x92FFD8)
    }
    
    class func tabGrey(_ mode: UIUserInterfaceStyle) -> UIColor {
        if mode == .dark {
            return background(.light)
        }
        return UIColor(red: 92/255.0, green: 97/255.0, blue: 113/255.0, alpha: 1.0)
    }
    class var tabGrey: UIColor {
        return tabGrey(.light)
    }
    
    // Used as background in calendar for overdue dates
    class func transparentRed(_ mode: UIUserInterfaceStyle) -> UIColor {
        if mode == .dark {
            return UIColor(red: 255/255.0, green: 0, blue: 0, alpha: 0.4)
        }
        return UIColor.rgb(fromHex: 0xFFCCCC)
    }
    
    class var paleRed: UIColor {
        return UIColor.rgb(fromHex: 0xF55C5C)
    }

    class func rgb(fromHex: Int) -> UIColor {
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
