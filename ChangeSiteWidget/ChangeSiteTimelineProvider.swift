//
//  ChangeSiteTimelineProvider.swift
//  ChangeSiteWidgetExtension
//
//  Created by Emily Mittleman on 1/23/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

struct ChangeSiteTimelineProvider: TimelineProvider {
  
  var pumpSiteManager = PumpSiteManager()

  func placeholder(in context: Context) -> PumpSiteEntry {
    PumpSiteEntry(date: .now, pumpSite: PumpSite())
  }

  func getSnapshot(in context: Context, completion: @escaping (PumpSiteEntry) -> ()) {
    let entry = PumpSiteEntry(date: .now, pumpSite: PumpSite())
    completion(entry)

    if context.isPreview {
      completion(entry)
    } else {
      completion(self.getPumpSiteEntry())
    }
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<PumpSiteEntry>) -> Void) {
    let pumpSiteEntry = self.getPumpSiteEntry()
    let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: .now)!
    let timeline = Timeline(entries: [pumpSiteEntry], policy: .after(nextUpdateDate))
    completion(timeline)
  }

  func getPumpSiteEntry() -> PumpSiteEntry {
    return PumpSiteEntry(date: .now, pumpSite: pumpSiteManager.getPumpSite())
  }
}
