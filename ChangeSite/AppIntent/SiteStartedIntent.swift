//
//  SiteStartedIntent.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 2/18/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import AppIntents
import Foundation

@available(iOS 16.0, *)
struct SiteStartedIntent: AppIntent {

  static var title: LocalizedStringResource = "Change Site"
  static var description = IntentDescription("Starts a new pump site.")

  private static let storage = UserDefaultsAccessHelper.sharedInstance

  func perform() async throws -> some IntentResult {
    PumpSiteManager().updatePumpSite(startDate: Date())
    return .result()
  }
}
