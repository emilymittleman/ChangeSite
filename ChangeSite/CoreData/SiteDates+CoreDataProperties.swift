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

    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var expiredDate: Date?

}

extension SiteDates : Identifiable {

}
