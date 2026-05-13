//
//  ChangeSiteTests.swift
//  ChangeSiteTests
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import XCTest
import CoreData
@testable import ChangeSite

class ChangeSiteTests: XCTestCase {

    var coreDataStack: CoreDataStack!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(modelName: "PumpSite", inMemory: true)
    }

    override func tearDown() {
        coreDataStack = nil
        super.tearDown()
    }

    // MARK: - Helper

    private func createSite(startDate: Date, endDate: Date?, daysBtwn: Int = 3) {
        let pumpSite = PumpSite(startDate: startDate, daysBtwn: daysBtwn)
        SiteDates.createOrUpdate(pumpSite: pumpSite, endDate: endDate, with: coreDataStack)
        coreDataStack.saveContext()
    }

    private func fetchAllSiteDates() -> [SiteDates] {
        let request: NSFetchRequest<SiteDates> = SiteDates.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(SiteDates.startDate), ascending: false)]
        return (try? coreDataStack.managedContext.fetch(request)) ?? []
    }

    // MARK: - SiteDates.delete tests

    func testDeleteRemovesRecordByStartDate() {
        let date = Date(timeIntervalSince1970: 1_000_000)
        createSite(startDate: date, endDate: nil)
        XCTAssertEqual(fetchAllSiteDates().count, 1)

        SiteDates.delete(startDate: date, with: coreDataStack)
        coreDataStack.saveContext()

        XCTAssertEqual(fetchAllSiteDates().count, 0)
    }

    func testDeleteDoesNotAffectOtherRecords() {
        let date1 = Date(timeIntervalSince1970: 1_000_000)
        let date2 = Date(timeIntervalSince1970: 2_000_000)
        createSite(startDate: date1, endDate: date2)
        createSite(startDate: date2, endDate: nil)
        XCTAssertEqual(fetchAllSiteDates().count, 2)

        SiteDates.delete(startDate: date1, with: coreDataStack)
        coreDataStack.saveContext()

        let remaining = fetchAllSiteDates()
        XCTAssertEqual(remaining.count, 1)
        XCTAssertEqual(remaining.first?.startDate, formatCoreDataDate(date2))
    }

    // MARK: - SiteDatesProvider.getPreviousSiteEndDate tests

    func testGetPreviousSiteEndDateReturnsNilWhenOnlyOneSite() {
        let date = Date(timeIntervalSince1970: 1_000_000)
        createSite(startDate: date, endDate: nil)

        let provider = SiteDatesProvider(with: coreDataStack.managedContext)
        XCTAssertNil(provider.getPreviousSiteEndDate())
    }

    func testGetPreviousSiteEndDateReturnsCorrectDate() {
        let date1 = Date(timeIntervalSince1970: 1_000_000)
        let date2 = Date(timeIntervalSince1970: 2_000_000)
        createSite(startDate: date1, endDate: date2)
        createSite(startDate: date2, endDate: nil)

        let provider = SiteDatesProvider(with: coreDataStack.managedContext)
        XCTAssertEqual(provider.getPreviousSiteEndDate(), formatCoreDataDate(date2))
    }

    // MARK: - Edit start date flow tests

    func testEditStartDateDeletesOldRecordAndCreatesNew() {
        let oldStart = Date(timeIntervalSince1970: 2_000_000)
        let previousEnd = Date(timeIntervalSince1970: 1_500_000)
        // Previous site
        createSite(startDate: Date(timeIntervalSince1970: 1_000_000), endDate: previousEnd)
        // Current site
        createSite(startDate: oldStart, endDate: nil)
        XCTAssertEqual(fetchAllSiteDates().count, 2)

        // Simulate editStartDate: delete old, create new
        let newStart = Date(timeIntervalSince1970: 1_800_000)
        SiteDates.delete(startDate: oldStart, with: coreDataStack)
        let newPumpSite = PumpSite(startDate: newStart, daysBtwn: 3)
        SiteDates.createOrUpdate(pumpSite: newPumpSite, endDate: nil, with: coreDataStack)
        coreDataStack.saveContext()

        let allSites = fetchAllSiteDates()
        XCTAssertEqual(allSites.count, 2, "Should still have 2 records (previous + edited current)")

        // Verify old record is gone
        let oldRecords = allSites.filter { $0.startDate == formatCoreDataDate(oldStart) }
        XCTAssertTrue(oldRecords.isEmpty, "Old record should be deleted")

        // Verify new record exists
        let newRecords = allSites.filter { $0.startDate == formatCoreDataDate(newStart) }
        XCTAssertEqual(newRecords.count, 1, "New record should exist")
        XCTAssertNil(newRecords.first?.endDate, "New current site should have nil endDate")
    }

    func testEditStartDateCannotBeBeforePreviousSiteEndDate() {
        let previousEnd = Date(timeIntervalSince1970: 1_500_000)
        createSite(startDate: Date(timeIntervalSince1970: 1_000_000), endDate: previousEnd)
        createSite(startDate: Date(timeIntervalSince1970: 2_000_000), endDate: nil)

        let provider = SiteDatesProvider(with: coreDataStack.managedContext)
        let minimumDate = provider.getPreviousSiteEndDate()

        // A date before the previous end should be rejected by the UI constraint
        let tooEarly = Date(timeIntervalSince1970: 1_400_000)
        XCTAssertNotNil(minimumDate)
        XCTAssertTrue(tooEarly < minimumDate!, "Date before previous site end should be invalid")
    }

    func testGetPreviousSiteEndDateReturnsNilWithNoSites() {
        let provider = SiteDatesProvider(with: coreDataStack.managedContext)
        XCTAssertNil(provider.getPreviousSiteEndDate())
    }
}
