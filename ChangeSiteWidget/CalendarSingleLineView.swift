//
//  SwiftUIView.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 1/29/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import SwiftUI
import WidgetKit

struct CalendarCellView: View {
  var date: Date
  var fillBackground: Bool = false
  var outline: Bool = false
  @Environment(\.colorScheme) var scheme: ColorScheme

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Text(dateFormatter("EEE").string(from: date).capitalized.prefix(3))
        .cs(font: CSFont(fontSize: 10, lineHeight: 10))
        .allowsTightening(true)
        .foregroundColor(UIColor.lightBlue)
        .lineLimit(1)
        .padding(.bottom, 2)

      ZStack {
        Circle()
          .stroke(outline ? Color(UIColor.charcoal(scheme)) : Color.clear, lineWidth: 1)
          .fill(fillBackground ? Color(UIColor.lightBlue) : Color.clear)

        Text(dateFormatter("d").string(from: date))
          .cs(font: CSFont(fontSize: 10)) // 12
          .foregroundColor(fillBackground ? UIColor.charcoal : UIColor.charcoal(scheme))
      }
      .frame(width: 18, height: 18) //20, 20
    }
  }
}

struct CalendarSingleLineView: View {
  let pumpSiteManager: PumpSiteManager
  var calendarCells: [CalendarCellView]
  @Environment(\.colorScheme) var scheme: ColorScheme

  init(pumpSiteManager: PumpSiteManager) {
    self.pumpSiteManager = pumpSiteManager
    self.calendarCells = []
    for i in 0...4 {
      let date = Calendar.current.date(byAdding: .day, value: i, to: pumpSiteManager.startDate) ?? Date()
      self.calendarCells.append(CalendarCellView(
        date: date,
        fillBackground: Date().get(.day) == date.get(.day),
        outline: i==0 || date.get(.day) == pumpSiteManager.endDate.get(.day)
      ))
    }
  }

  var body: some View {
    HStack(alignment: .center) {
      Spacer(minLength: 0)
      ForEach(calendarCells.indices, id: \.self) { i in
        calendarCells[i]
          .padding(2)
        Spacer(minLength: 0)
      }
    }
  }
}

struct CalendarSingleLineView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CalendarSingleLineView(pumpSiteManager: defaultPumpSiteManager)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .preferredColorScheme(.dark)

      CalendarCellView(date: Date(), fillBackground: false, outline: true)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDisplayName("Calendar Cell")
    }
    .environment(\.colorScheme, .dark)
    .containerBackground(for: .widget) {
      Color(UIColor.charcoal)
    }
  }
}
