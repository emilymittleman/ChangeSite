//
//  Objects.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/12/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

public func formatSiteDate(_ date: Date) -> Date {
    return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date) ?? date
}

extension UIColor {
    
    // Light mode -> white, Dark mode -> charcoal
    class func background(_ mode: UIUserInterfaceStyle) -> UIColor {
        if mode == .dark {
            return charcoal
        }
        return UIColor.systemBackground.resolvedColor(with: UITraitCollection.init(userInterfaceStyle: .light))
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
        return UIColor(red: 92/255.0, green: 109/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    class var tabGrey: UIColor {
        return UIColor(red: 92/255.0, green: 97/255.0, blue: 113/255.0, alpha: 1.0)
    }
    
    // Used as background in calendar for overdue dates
    class var transparentRed: UIColor {
        return UIColor.rgb(fromHex: 0xFFCCCC)
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
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
