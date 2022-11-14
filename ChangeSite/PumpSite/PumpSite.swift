//
//  PumpSite.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 10/6/20.
//  Copyright © 2020 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

class PumpSite : Codable {
    private var startDate : Date
    private var daysBtwn : Int
    private var endDate : Date
    private var overdue : Bool
    
    init(startDate: Date, daysBtwn: Int) {
        self.startDate = startDate
        self.daysBtwn = daysBtwn
        
        self.endDate = startDate
        self.endDate.addTimeInterval(TimeInterval(daysBtwn * 60 * 60 * 24))
        
        self.overdue = self.endDate < Date()
    }
    
    // MARK: GETTERS
    func getStartDate() -> Date { return startDate }
    func getEndDate() -> Date { return endDate }
    func getDaysBtwn() -> Int { return daysBtwn }
    func isOverdue() -> Bool {
        self.overdue = self.endDate < Date()
        return self.overdue
    }
    
    // MARK: SETTERS
    func setStartDate(startDate: Date) {
        self.startDate = startDate
        // reset endDate
        self.endDate = startDate
        self.endDate.addTimeInterval(TimeInterval(daysBtwn * 60 * 60 * 24))
        // reset if overdue
        self.overdue = self.endDate < Date()
    }
    
    // need to update CoreData with new expiredDate too
    func setDaysBtwn(daysBtwn: Int) {
        self.daysBtwn = daysBtwn
        // reset endDate
        self.endDate = startDate
        self.endDate.addTimeInterval(TimeInterval(daysBtwn * 60 * 60 * 24))
        // reset if overdue
        self.overdue = self.endDate < Date()
    }
}
