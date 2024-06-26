//
//  SiteDatesProvider.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/12/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SiteDatesProvider {
  private(set) var managedContext: NSManagedObjectContext
  public var siteDates = [SiteDates]()

  init(with managedContext: NSManagedObjectContext) {
    self.managedContext = managedContext
    self.fetchData()
  }

  public func fetchData() {
    let fetchRequest: NSFetchRequest<SiteDates> = SiteDates.fetchRequest()
    // sorts in reverse order, so that most recent pump sites come first
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(SiteDates.startDate), ascending: false)]
    do {
      let results = try self.managedContext.fetch(fetchRequest)
      self.siteDates = results
    } catch let error as NSError {
      print("Fetch error: \(error) description: \(error.userInfo)")
    }
  }

  public func getCurrentSite() -> SiteDates? {
    if siteDates.count == 0 {
      fetchData()
      if siteDates.count == 0 { return nil }
    }
    return siteDates[0]
  }

  public func getChangeDates() -> Set<Date?> {
    return Set(siteDates.map { $0.startDate })
  }

  public func getOverdueDates() -> Set<Date?> {
    let overdueSites = siteDates.filter{ $0.daysOverdue > 0 }
    var overdueDates = Set<Date?>()
    for site in overdueSites {
      var date = site.expiredDate
      var end = site.endDate
      if date == nil { continue } //should never be nil

      // set endDate to current day if site is current session
      if end == nil {
        if isCurrentSite(site) {
          end = formatCoreDataDate(.now)
        } else { continue }
      }

      while date! < end! {
        date = Calendar.current.date(byAdding: .day, value: 1, to: date!)
        overdueDates.insert(date!)
      }
    }
    return overdueDates
  }

  private func isCurrentSite(_ site: SiteDates) -> Bool {
    return site.startDate == self.siteDates[0].startDate
  }

  public func deleteAllEntries() {
    for siteDate in siteDates {
      AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(siteDate)
    }
    AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
  }
}
