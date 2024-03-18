//
//  ChangeSiteWidgetView.swift
//  ChangeSiteWidgetExtension
//
//  Created by Emily Mittleman on 1/23/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import SwiftUI
import WidgetKit

//struct NextChangeLabel: View {
//  var endDate: Date
//  @Environment(\.colorScheme) var scheme: ColorScheme
//
//  var body: some View {
//    VStack(alignment: .center) {
//      Text("Next change: " + getWeekday(from: endDate).capitalized)
//        .cs(font: CSFont(fontSize: 11))
//        .foregroundColor(UIColor.charcoal(scheme))
//        .multilineTextAlignment(.center)
//    }
//  }
//}

struct CountdownLabel: View {
  var pumpSiteManager: PumpSiteManager
  @Environment(\.colorScheme) var scheme: ColorScheme

  var body: some View {
    VStack(alignment: .center) {
      Text(getCountdownText(pumpSiteManager))
        .cs(font: CSFont(fontSize: 20, lineHeight: 20))
        .foregroundColor(pumpSiteManager.overdue ? UIColor.paleRed : UIColor.charcoal(scheme))
    }
  }
}

struct NewSiteStartedButton: View {
  var pumpSiteManager: PumpSiteManager
  @Environment(\.colorScheme) var scheme: ColorScheme

  var body: some View {
    Button(intent: SiteStartedIntent()) {
      //Text(entry.startDate, style: .time)
      Text("New Site")
        .cs(font: CSFont(fontSize: 12))
        .foregroundColor(UIColor.lightBlue) //charcoal(scheme))
        .padding(.horizontal, 8)
    }
    .tint(Color.clear)
    .background(
      RoundedRectangle(cornerRadius: 14)
        .stroke(Color(UIColor.lightBlue), lineWidth: 1.5)
    )
  }
}

struct ChangeSiteWidgetView: View {
  var entry: ChangeSiteTimelineProvider.Entry
  var pumpSiteManager: PumpSiteManager
  @Environment(\.colorScheme) var scheme: ColorScheme

  init(entry: ChangeSiteTimelineProvider.Entry) {
    self.entry = entry
    self.pumpSiteManager = PumpSiteManager(
      startDate: entry.startDate, daysBtwn: entry.daysBtwn
    )
  }

  var body: some View {
    VStack(alignment: .center) {
      CalendarSingleLineView(pumpSiteManager: pumpSiteManager)
      Spacer()
      //NextChangeLabel(endDate: pumpSiteManager.endDate)
      CountdownLabel(pumpSiteManager: pumpSiteManager)
      Spacer()
      NewSiteStartedButton(pumpSiteManager: pumpSiteManager)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .environment(\.colorScheme, .dark)
    .containerBackground(for: .widget) {
      Color(UIColor.background(ColorScheme.dark))
    }
  }
}

#Preview(as: .systemSmall) {
  ChangeSiteWidget()
} timeline: {
  defaultPumpSiteEntry
}
