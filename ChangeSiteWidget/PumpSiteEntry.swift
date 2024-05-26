//
//  PumpSiteEntry.swift
//  ChangeSiteWidgetExtension
//
//  Created by Emily Mittleman on 5/25/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import WidgetKit

public let defaultPumpSiteEntry = PumpSiteEntry(date: .now, pumpSite: PumpSite())

public struct PumpSiteEntry: TimelineEntry {
  public let date: Date // The date for WidgetKit to render a widget
  public let pumpSite: PumpSite

  public init(date: Date, pumpSite: PumpSite) {
    self.date = date
    self.pumpSite = pumpSite
  }
}
