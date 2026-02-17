//
//  ChangeSiteWidget.swift
//  ChangeSiteWidget
//
//  Created by Emily Mittleman on 1/23/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import WidgetKit
import SwiftUI

struct ChangeSiteWidget: Widget {
  let kind: String = "ChangeSiteWidget"

  init() {
    UserDefaultsAccessHelper.sharedInstance.setUp(withGroupID: Bundle.main.appGroupID)
    let pumpSiteManager = PumpSiteManager()
    let remindersManager = RemindersManager()
    NotificationManager.setup(NotificationManager.Config(pumpSiteManager: pumpSiteManager, remindersManager: remindersManager))
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
