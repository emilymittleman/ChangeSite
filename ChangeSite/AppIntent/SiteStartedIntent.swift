//
//  SiteStartedIntent.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 2/18/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import AppIntents
import Foundation
import OSLog

fileprivate let log = Logger()

@available(iOS 16.0, *)
struct SiteStartedIntent: AppIntent {

  static var title: LocalizedStringResource = "Change Site"
  static var description = IntentDescription("Starts a new pump site.")

  private static let storage = UserDefaultsAccessHelper.sharedInstance
  private static let pumpSiteManager = PumpSiteManager()

  func perform() async throws -> some IntentResult {
    log.log("New site started")
    SiteStartedIntent.pumpSiteManager.updatePumpSite(startDate: .now)
    return .result()
  }
}
