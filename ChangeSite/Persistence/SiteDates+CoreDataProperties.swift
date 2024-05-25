//
//  SiteDates+CoreDataProperties.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/12/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension SiteDates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SiteDates> {
        return NSFetchRequest<SiteDates>(entityName: "SiteDates")
    }

    // for each date, ONLY store day,month,year,hour=0,minute=0,seconds=0
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var expiredDate: Date?
    @NSManaged public var daysOverdue: Int32
}

public extension SiteDates {
    
    internal class func createOrUpdate(pumpSiteManager: PumpSiteManager, endDate: Date?, with stack: CoreDataStack) {
        var incomingStartDate = pumpSiteManager.startDate
        incomingStartDate = formatCoreDataDate(incomingStartDate)
        
        var currentSiteDates: SiteDates? // Entity name
        let fetchRequest: NSFetchRequest<SiteDates> = SiteDates.fetchRequest()
        let startDatePredicate = NSPredicate(format: "%K == %@", #keyPath(SiteDates.startDate), incomingStartDate as NSDate)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [startDatePredicate])
        
        do {
            let results = try stack.managedContext.fetch(fetchRequest)
            if results.isEmpty {
                // startDate not found, create a new one
                currentSiteDates = SiteDates(context: stack.managedContext)
                currentSiteDates?.startDate = incomingStartDate
            } else {
                // startDate found, use it
                currentSiteDates = results.first
            }
            currentSiteDates?.update(pumpSiteManager: pumpSiteManager, endDate: endDate)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    // need to guarantee that nextStartDate can't be earlier than original startDate
    internal func update(pumpSiteManager: PumpSiteManager, endDate: Date?) {
        self.endDate = endDate == nil ? nil : formatCoreDataDate(endDate!)
        self.expiredDate = formatCoreDataDate(pumpSiteManager.endDate)
        self.daysOverdue = 0
        if pumpSiteManager.overdue {
            // find days btwn expire date & change date (or today if not changed yet, so endDate==nil)
          let numberOfDays = signedDaysBetweenDates(from: pumpSiteManager.endDate, to: endDate ?? .now)
            self.daysOverdue = numberOfDays < 0 ? 0 : Int32(numberOfDays)
        }
    }
    
    internal class func testing_addEntry(startDate: Date, expiredDate: Date, daysOverdue: Int, with stack: CoreDataStack) {
        let newSite = SiteDates(context: stack.managedContext)
        newSite.startDate = startDate
        newSite.expiredDate = expiredDate
        newSite.endDate = Date(timeInterval: TimeInterval(daysOverdue * AppConstants.secondsPerDay), since: expiredDate)
        newSite.daysOverdue = Int32(daysOverdue)
    }
}

extension SiteDates : Identifiable {
    
}
