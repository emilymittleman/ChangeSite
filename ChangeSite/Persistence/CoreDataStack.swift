//
//  CoreDataStack.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/12/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  private let modelName: String
  // Only used for testing
  private let inMemory: Bool

  init(modelName: String, inMemory: Bool = false) {
    self.modelName = modelName
    self.inMemory = inMemory
  }

  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    if inMemory {
      let description = NSPersistentStoreDescription()
      description.type = NSInMemoryStoreType
      container.persistentStoreDescriptions = [description]
    }
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext

  func saveContext() {
    guard managedContext.hasChanges else { return }
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
}
