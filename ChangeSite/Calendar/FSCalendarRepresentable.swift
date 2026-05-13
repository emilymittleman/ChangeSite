//
//  FSCalendarRepresentable.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//
//  UIViewRepresentable wrapper for FSCalendar.
//  Used as a placeholder in SwiftUI views until a first-party SwiftUI
//  calendar solution is viable or FSCalendar ships a native SwiftUI wrapper.
//
//  Two modes:
//    .week  — Home tab: week scope, scroll disabled, no month header
//    .month — Calendar tab: month scope, horizontal scroll, custom cell coloring
//
//  TODO: revisit when FSCalendar ships a SwiftUI wrapper or a suitable
//        first-party alternative becomes available.
//

import FSCalendar
import SwiftUI

// MARK: - Mode

enum FSCalendarMode {
  /// Week scope used on the Home tab: scrolling disabled, no header, single-week view.
  case week
  /// Month scope used on the Calendar tab: horizontal paging, custom cell coloring for
  /// overdue dates and change dates.
  case month
}

// MARK: - Representable

struct FSCalendarRepresentable: UIViewRepresentable {

  // MARK: Inputs

  let mode: FSCalendarMode

  /// Currently selected / highlighted date. In week mode the calendar marks
  /// the pump site end date; in month mode selection is disabled.
  @Binding var selectedDate: Date

  /// Dates on which a site was started (marked with a circle stroke in month mode).
  var changedSiteDates: Set<Date?>

  /// Dates that were overdue (highlighted red background in month mode).
  var overdueDates: Set<Date?>

  // MARK: makeUIView

  func makeUIView(context: Context) -> FSCalendar {
    let calendar = FSCalendar()
    calendar.dataSource = context.coordinator
    calendar.delegate  = context.coordinator

    // Shared appearance
    calendar.backgroundColor = UIColor.custom.background
    calendar.appearance.todayColor            = UIColor.custom.lightBlue
    calendar.appearance.weekdayTextColor      = UIColor.custom.lightBlue
    calendar.appearance.titleDefaultColor     = UIColor.custom.textPrimary
    calendar.appearance.titleTodayColor       = UIColor.custom.background
    calendar.appearance.headerTitleColor      = UIColor.custom.textTertiary
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0

    switch mode {
    case .week:
      configureWeekMode(calendar)
    case .month:
      configureMonthMode(calendar, coordinator: context.coordinator)
    }

    return calendar
  }

  // MARK: updateUIView

  func updateUIView(_ calendar: FSCalendar, context: Context) {
    context.coordinator.changedSiteDates = changedSiteDates
    context.coordinator.overdueDates     = overdueDates
    context.coordinator.selectedDate     = selectedDate
    calendar.reloadData()
  }

  // MARK: makeCoordinator

  func makeCoordinator() -> Coordinator {
    Coordinator(
      mode: mode,
      selectedDate: $selectedDate,
      changedSiteDates: changedSiteDates,
      overdueDates: overdueDates
    )
  }

  // MARK: Private configuration helpers

  private func configureWeekMode(_ calendar: FSCalendar) {
    calendar.scope = .week
    calendar.scrollEnabled = false
    calendar.allowsSelection = false
    calendar.today = .now
    calendar.swipeToChooseGesture.isEnabled = false

    // No month header in week mode
    calendar.appearance.headerDateFormat = ""
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0

    calendar.appearance.weekdayFont = UIFont(name: "Rubik-Regular", size: 15)
    calendar.appearance.titleFont   = UIFont(name: "Rubik-Regular", size: 17)

    calendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "cell")
  }

  private func configureMonthMode(_ calendar: FSCalendar, coordinator: Coordinator) {
    calendar.scope = .month
    calendar.scrollDirection = .horizontal
    calendar.allowsSelection = false
    calendar.today = .now
    calendar.swipeToChooseGesture.isEnabled = true

    calendar.appearance.weekdayFont      = UIFont(name: "Rubik-Regular", size: 17)
    calendar.appearance.titleFont        = UIFont(name: "Rubik-Regular", size: 15)
    calendar.appearance.headerTitleFont  = UIFont(name: "Rubik-Regular", size: 20)

    calendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "cell")
  }

  // MARK: - Coordinator

  final class Coordinator: NSObject, FSCalendarDataSource, FSCalendarDelegate {

    let mode: FSCalendarMode
    @Binding var selectedDate: Date
    var changedSiteDates: Set<Date?>
    var overdueDates: Set<Date?>

    init(
      mode: FSCalendarMode,
      selectedDate: Binding<Date>,
      changedSiteDates: Set<Date?>,
      overdueDates: Set<Date?>
    ) {
      self.mode = mode
      self._selectedDate = selectedDate
      self.changedSiteDates = changedSiteDates
      self.overdueDates = overdueDates
    }

    // MARK: FSCalendarDataSource

    func calendar(
      _ calendar: FSCalendar,
      cellFor date: Date,
      at position: FSCalendarMonthPosition
    ) -> FSCalendarCell {
      calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
    }

    func calendar(
      _ calendar: FSCalendar,
      willDisplay cell: FSCalendarCell,
      for date: Date,
      at position: FSCalendarMonthPosition
    ) {
      configure(cell: cell, for: date, at: position)
    }

    // MARK: FSCalendarDelegate

    func calendar(
      _ calendar: FSCalendar,
      boundingRectWillChange bounds: CGRect,
      animated: Bool
    ) {
      // Allow FSCalendar to resize itself; the SwiftUI layout engine will
      // pick up the intrinsic content size change on the next pass.
      calendar.frame.size.height = bounds.height
    }

    // MARK: Private cell configuration

    private func configure(
      cell: FSCalendarCell,
      for date: Date,
      at position: FSCalendarMonthPosition
    ) {
      guard let cell = cell as? CustomCalendarCell else { return }

      switch mode {
      case .week:
        configureWeekCell(cell, for: date, at: position)
      case .month:
        configureMonthCell(cell, for: date, at: position)
      }
    }

    /// Week mode: mark only the current pump-site end date with a circle.
    private func configureWeekCell(
      _ cell: CustomCalendarCell,
      for date: Date,
      at position: FSCalendarMonthPosition
    ) {
      guard position == .current else {
        cell.backgroundColor = .clear
        cell.selectionLayer.isHidden = true
        cell.isSelected = false
        return
      }

      if isSameDay(date, selectedDate) {
        cell.selectionLayer.isHidden = false
        cell.isSelected = true
      } else {
        cell.selectionLayer.isHidden = true
        cell.isSelected = false
      }
      cell.backgroundColor = .clear
    }

    /// Month mode: red background for overdue dates, circle for change dates.
    private func configureMonthCell(
      _ cell: CustomCalendarCell,
      for date: Date,
      at position: FSCalendarMonthPosition
    ) {
      guard position == .current else {
        cell.backgroundColor = .clear
        cell.selectionLayer.isHidden = true
        cell.isSelected = false
        return
      }

      // Overdue highlight
      if overdueDates.contains(date) {
        cell.backgroundColor = UIColor.custom.redHighlight
      } else {
        cell.backgroundColor = .clear
      }

      // Change-date circle
      if changedSiteDates.contains(date) {
        cell.selectionLayer.isHidden = false
        cell.isSelected = true
      } else {
        cell.selectionLayer.isHidden = true
        cell.isSelected = false
      }
    }

    private func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
      Calendar.current.startOfDay(for: d1) == Calendar.current.startOfDay(for: d2)
    }
  }
}

// MARK: - Preview

#Preview("FSCalendarRepresentable — week") {
  FSCalendarRepresentable(
    mode: .week,
    selectedDate: .constant(Date()),
    changedSiteDates: [],
    overdueDates: []
  )
  .frame(height: 120)
  .background(Color.custom.background)
}

#Preview("FSCalendarRepresentable — month") {
  FSCalendarRepresentable(
    mode: .month,
    selectedDate: .constant(Date()),
    changedSiteDates: [Calendar.current.date(byAdding: .day, value: -3, to: .now)],
    overdueDates: [Calendar.current.date(byAdding: .day, value: -1, to: .now)]
  )
  .frame(height: 320)
  .background(Color.custom.background)
}
