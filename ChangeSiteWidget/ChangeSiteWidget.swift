//
//  ChangeSiteWidget.swift
//  ChangeSiteWidget
//
//  Created by Emily Mittleman on 1/23/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import WidgetKit
import SwiftUI

public let defaultPumpSiteManager = PumpSiteManager(startDate: .now, daysBtwn: 3)
public let defaultPumpSiteEntry = PumpSiteEntry(date: .now, startDate: .now, daysBtwn: 3)

public struct PumpSiteEntry: TimelineEntry {
  public let date: Date // The date for WidgetKit to render a widget
  public let startDate: Date
  public let daysBtwn: Int

  public init(date: Date, startDate: Date, daysBtwn: Int) {
    self.date = date
    self.startDate = startDate
    self.daysBtwn = daysBtwn
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
      if #available(iOS 17.0, *) {
        ChangeSiteWidgetView(entry: entry)
        //.containerBackground(.fill.tertiary, for: .widget)
      } else {
        ChangeSiteWidgetView(entry: entry)
//          .padding()
//          .background()
      }
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

#Preview(as: .systemSmall) {
  ChangeSiteWidget()
} timeline: {
  defaultPumpSiteEntry
}
