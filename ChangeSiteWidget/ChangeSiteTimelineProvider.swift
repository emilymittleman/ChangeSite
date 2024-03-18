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
  func placeholder(in context: Context) -> PumpSiteEntry {
    PumpSiteEntry(date: .now, startDate: .now, daysBtwn: 3)
  }

  func getSnapshot(in context: Context, completion: @escaping (PumpSiteEntry) -> ()) {
    let entry = PumpSiteEntry(date: .now, startDate: .now, daysBtwn: 3)
    completion(entry)

    if context.isPreview {
      completion(entry)
    } else {
      Self.getPumpSiteEntry() { pumpSiteEntry in
        completion(pumpSiteEntry)
      }
    }
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<PumpSiteEntry>) -> Void) {
    Self.getPumpSiteEntry() { pumpSiteEntry in
      let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
      let timeline = Timeline(entries: [pumpSiteEntry], policy: .after(nextUpdateDate))
      completion(timeline)
    }
  }

  static func getPumpSiteEntry(completion: @escaping (PumpSiteEntry) -> Void) {
    completion(PumpSiteEntry(date: .now, startDate: .now, daysBtwn: 3))
  }
}
