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

    // for each date, ONLY store day,month,year
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var expiredDate: Date?

}

public extension SiteDates {
    
    internal class func createOrUpdate(pumpSite: PumpSite, endDate: Date, with stack: CoreDataStack) {
        incomingStartDate = 
        
        
        let newsItemID = item.id
        var currentNewsPost: NewsPosts? // Entity name
        let newsPostFetch: NSFetchRequest<NewsPosts> = NewsPosts.fetchRequest()
        if let newsItemID = newsItemID {
            let newsItemIDPredicate = NSPredicate(format: "%K == %i", #keyPath(NewsPosts.postID), newsItemID)
            newsPostFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newsItemIDPredicate])
        }
        do {
            let results = try stack.managedContext.fetch(newsPostFetch)
            if results.isEmpty {
                // News post not found, create a new.
                currentNewsPost = NewsPosts(context: stack.managedContext)
                if let postID = newsItemID {
                    currentNewsPost?.postID = Int32(postID)
                }
            } else {
                // News post found, use it.
                currentNewsPost = results.first
            }
            currentNewsPost?.update(pumpSite: pumpSite, endDate: endDate)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    internal func endedCurrentSite(pumpSite: PumpSite, endDate: Date) {
        self.endDate = endDate
        self.expiredDate = pumpSite.getEndDate()
    }
    
    // maybe pass in a PumpSite object instead
    // need to guarantee that nextStartDate can't be earlier than original startDate
    internal func update(pumpSite: PumpSite, endDate: Date) {
        self.endDate = nextStartDate
        self.expiredDate = pumpSite.getEndDate()
    }
}

extension SiteDates : Identifiable {
    
}
