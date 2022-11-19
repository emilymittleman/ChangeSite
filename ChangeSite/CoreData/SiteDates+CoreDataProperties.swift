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

    // for each date, ONLY store day,month,year,hour=12,minute=0,seconds=0
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var expiredDate: Date?
    @NSManaged public var daysOverdue: Int32
}

public extension SiteDates {
    
    internal class func createOrUpdate(pumpSiteManager: PumpSiteManager, endDate: Date?, with stack: CoreDataStack) {
        var incomingStartDate = pumpSiteManager.getStartDate()
        incomingStartDate = formatSiteDate(incomingStartDate)
        
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
        self.endDate = endDate == nil ? nil : formatSiteDate(endDate!)
        self.expiredDate = formatSiteDate(pumpSiteManager.getEndDate())
        self.daysOverdue = 0
        if pumpSiteManager.isOverdue() {
            // find days btwn expire date & change date (or today if not changed yet, so endDate==nil)
            let numberOfDays = Calendar.current.dateComponents([.day], from: pumpSiteManager.getEndDate(), to: endDate ?? Date()).day ?? 0
            self.daysOverdue = Int32(numberOfDays)
        }
        print("endDate: \(String(describing: self.endDate)), expired: \(String(describing: self.expiredDate)), daysOver: \(self.daysOverdue)")
    }
    
}

extension SiteDates : Identifiable {
    
}
