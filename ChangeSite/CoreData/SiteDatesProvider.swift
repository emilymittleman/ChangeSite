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
    
    /*private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    init(with managedObjectContext: NSManagedObjectContext,
         fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?) {
        self.managedObjectContext = managedObjectContext
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }
    
    /**
     A fetched results controller for the SiteDates entity, sorted by date.
     */
    lazy var fetchedResultsController: NSFetchedResultsController<SiteDates> = {
        let fetchRequest: NSFetchRequest<SiteDates> = SiteDates.fetchRequest()
        // sorts in reverse order, so that most recent pump sites come first
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(SiteDates.startDate), ascending: false)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest, managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            print("Fetch failed")
        }
        
        return controller
    }()*/
}
