//
//  ChangeSiteWidget.swift
//  ChangeSiteWidget
//
//  Created by Emily Mittleman on 1/23/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import WidgetKit
import SwiftUI

public let defaultPumpSiteEntry = PumpSiteEntry(date: .now, pumpSite: PumpSite())

public struct PumpSiteEntry: TimelineEntry {
  public let date: Date // The date for WidgetKit to render a widget
  public let pumpSite: PumpSite

  public init(date: Date, pumpSite: PumpSite) {
    self.date = date
    self.pumpSite = pumpSite
  }
}

struct ChangeSiteWidget: Widget {
  let kind: String = "ChangeSiteWidget"

  init() {
    let groupId = Bundle.main.appGroupID
    UserDefaultsAccessHelper.sharedInstance.setUp(withGroupID: groupId)
  }

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: ChangeSiteTimelineProvider()) { entry in
      ChangeSiteWidgetView(entry: entry)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .configurationDisplayName("Pump Site Countdown")
    .description("Display time until next pump site change")
  }
}

#Preview(as: .systemSmall) {
  ChangeSiteWidget()
} timeline: {
  defaultPumpSiteEntry
}
