//
//  ChangeSiteWidgetView.swift
//  ChangeSiteWidgetExtension
//
//  Created by Emily Mittleman on 1/23/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ChangeSiteWidgetView: View {
  var entry: ChangeSiteTimelineProvider.Entry
  var pumpSite: PumpSite
  @Environment(\.colorScheme) var scheme: ColorScheme

  init(entry: ChangeSiteTimelineProvider.Entry) {
    self.entry = entry
    self.pumpSite = entry.pumpSite
  }

  var body: some View {
    VStack(alignment: .center) {
      CalendarSingleLineView(pumpSite: pumpSite)
      Spacer()
      CountdownLabel(pumpSite: pumpSite)
      Spacer()
      NewSiteStartedButton()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .containerBackground(for: .widget) {
      Color.custom.background
    }
    .padding(.horizontal, -2)
    .padding(.vertical, -2)
    //.widgetBackground()
  }
}

struct CountdownLabel: View {
  var pumpSite: PumpSite
  @Environment(\.colorScheme) var scheme: ColorScheme

  var body: some View {
    VStack(alignment: .center) {
      Text(getCountdownText(pumpSite))
        .cs(font: CSFont(fontSize: 20, bold: true))
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .foregroundColor(pumpSite.overdue ? Color.custom.redText : Color.custom.textPrimary)
    }
  }
}

//struct NextChangeLabel: View {
//  var endDate: Date
//  @Environment(\.colorScheme) var scheme: ColorScheme
//
//  var body: some View {
//    VStack(alignment: .center) {
//      Text("Next change: " + getWeekday(from: endDate).capitalized)
//        .cs(font: CSFont(fontSize: 11))
//        .foregroundColor(Color.charcoal(scheme))
//        .multilineTextAlignment(.center)
//    }
//  }
//}

struct NewSiteStartedButton: View {
  @Environment(\.colorScheme) var scheme: ColorScheme

  var body: some View {
    Button(intent: SiteStartedIntent()) {
      //Text(entry.startDate, style: .time)
      Text("New Site")
        .cs(font: CSFont(fontSize: 12))
        .foregroundColor(Color.custom.lightBlue)
        .padding(.horizontal, 8)
    }
    .tint(Color.clear)
    .background(
      RoundedRectangle(cornerRadius: 14)
        .stroke(Color(Color.custom.lightBlue), lineWidth: 1.5)
    )
  }
}

#Preview(as: .systemSmall) {
  ChangeSiteWidget()
} timeline: {
  defaultPumpSiteEntry
}
