//
//  StartDatePickerSheet.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//
//  SwiftUI replacement for StartDatePickerBottomSheet.
//  Present via .sheet(isPresented:) with .presentationDetents([.height(300)]).
//

import SwiftUI

// MARK: - StartDatePickerSheet

/// A bottom-sheet style date picker that lets the user choose a pump-site
/// start date. Mirrors the UIKit `StartDatePickerBottomSheet` exactly:
///
/// - Header (40 pt, lightBlue background): Cancel | title | Save
/// - Body: `ThirtyMinuteDatePicker` (dateAndTime, wheels, 30-min interval)
/// - Initial date: today at the stored default-change-time hour:minute,
///   snapped to the nearest 30-minute boundary.
///
/// Usage:
/// ```swift
/// .sheet(isPresented: $showPicker) {
///   StartDatePickerSheet(isPresented: $showPicker) { chosenDate in
///     pumpSiteManager.changedSite(changeDate: chosenDate)
///   }
/// }
/// ```
struct StartDatePickerSheet: View {

  @Binding var isPresented: Bool

  /// Called with the chosen `Date` when the user taps "Save".
  let onSave: (Date) -> Void

  @State private var selectedDate: Date = .now

  var body: some View {
    VStack(spacing: 0) {
      headerBar
      ThirtyMinuteDatePicker(selection: $selectedDate)
        .frame(maxWidth: .infinity)
    }
    .onAppear {
      selectedDate = initialPickerDate()
    }
    // Sheet presentation modifiers — applied by the caller's .sheet modifier,
    // but also declared here so previews and hosted contexts get the same shape.
    .presentationDetents([.height(300)])
    .presentationDragIndicator(.hidden)
  }

  // MARK: - Header bar

  private var headerBar: some View {
    ZStack {
      Color.custom.lightBlue
        .frame(height: 40)

      HStack {
        Button("Cancel") {
          isPresented = false
        }
        .font(.rubik(.medium, 17))
        .foregroundStyle(Color.custom.background)
        .accessibilityIdentifier("startDatePickerCancelButton")

        Spacer()

        Text("Choose your start date")
          .font(.rubik(.medium, 19))
          .foregroundStyle(Color.custom.background)
          .lineLimit(1)
          .minimumScaleFactor(0.7)

        Spacer()

        Button("Save") {
          onSave(selectedDate)
          isPresented = false
        }
        .font(.rubik(.medium, 17))
        .foregroundStyle(Color.custom.background)
        .accessibilityIdentifier("startDatePickerSaveButton")
      }
      .padding(.horizontal, 10)
    }
    .frame(height: 40)
  }

  // MARK: - Initial date logic

  /// Mirrors the UIKit `showInView` logic:
  /// 1. Read the stored default-change-time from UserDefaults.
  /// 2. Apply its hour + minute to today.
  /// 3. Snap to the nearest 30-minute boundary (floor) via `formatDate`.
  private func initialPickerDate() -> Date {
    let base: Date
    if let stored = UserDefaultsAccessHelper.sharedInstance.date(for: .defaultChangeTime) {
      let hour   = Calendar.current.component(.hour,   from: stored)
      let minute = Calendar.current.component(.minute, from: stored)
      base = Calendar.current.date(
        bySettingHour: hour, minute: minute, second: 0, of: .now
      ) ?? .now
    } else {
      base = .now
    }
    // formatDate snaps minutes down to the nearest 30-minute boundary.
    return formatDate(base)
  }
}

// MARK: - Preview

#Preview("StartDatePickerSheet") {
  @Previewable @State var shown = true
  Color.custom.background
    .ignoresSafeArea()
    .sheet(isPresented: $shown) {
      StartDatePickerSheet(isPresented: $shown) { date in
        print("Saved:", date)
      }
    }
}
