//
//  SwiftUIView.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 1/29/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import SwiftUI
import WidgetKit

struct CalendarSingleLineView: View {
  let pumpSite: PumpSite
  var calendarCells: [CalendarCellView]

  init(pumpSite: PumpSite) {
    self.pumpSite = pumpSite
    self.calendarCells = []
    for i in 0...4 {
      let date = Calendar.current.date(byAdding: .day, value: i, to: pumpSite.startDate) ?? .now
      self.calendarCells.append(CalendarCellView(
        date: date,
        fillBackground: Date.now.get(.day) == date.get(.day),
        outline: i==0 || date.get(.day) == pumpSite.expiration.get(.day)
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

struct CalendarCellView: View {
  var date: Date
  var fillBackground: Bool = false
  var outline: Bool = false

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Text(dateFormatter("EEE").string(from: date).capitalized.prefix(3))
        .cs(font: CSFont(fontSize: 10))
        .allowsTightening(true)
        .foregroundColor(Color.custom.lightBlue)
        .lineLimit(1)
        .padding(.bottom, 2)

      ZStack {
        Circle()
          .stroke(outline ? Color.custom.textPrimary : Color.clear, lineWidth: 1)
          .fill(fillBackground ? Color.custom.lightBlue : Color.clear)

        Text(dateFormatter("d").string(from: date))
          .cs(font: CSFont(fontSize: 10)) // 12
          .foregroundColor(fillBackground ? Color.custom.background : Color.custom.textPrimary)
      }
      .frame(width: 18, height: 18) //20, 20
    }
  }
}

struct CalendarSingleLineView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CalendarSingleLineView(pumpSite: PumpSite())
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .preferredColorScheme(.dark)

      CalendarCellView(date: .now, fillBackground: false, outline: true)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDisplayName("Calendar Cell")
    }
    .environment(\.colorScheme, .dark)
    .containerBackground(for: .widget) {
      Color(Color.custom.background)
    }
  }
}
