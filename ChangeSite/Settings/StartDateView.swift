//
//  StartDateView.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//

import SwiftUI

struct StartDateView: View {

  @EnvironmentObject var pumpSiteManager: PumpSiteManager
  @Environment(\.dismiss) private var dismiss

  @State private var selectedDate: Date = .now
  private let originalDate: Date

  init(pumpSiteManager: PumpSiteManager) {
    self.originalDate = pumpSiteManager.startDate
    _selectedDate = State(initialValue: pumpSiteManager.startDate)
  }

  private var hasChanges: Bool {
    !Calendar.current.isDate(selectedDate, equalTo: originalDate, toGranularity: .minute)
  }

  var body: some View {
    ZStack(alignment: .top) {
      Color.custom.background
        .ignoresSafeArea()

      VStack(spacing: 32) {
        // Title with lightBlue bottom underline
        VStack(alignment: .leading, spacing: 0) {
          Text("Set Start Date")
            .font(.rubikHeader30)
            .foregroundColor(Color.custom.textPrimary)

          Rectangle()
            .fill(Color.custom.lightBlue)
            .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.top, 24)

        minDatePicker

        if hasChanges {
          Button {
            pumpSiteManager.editStartDate(from: originalDate, to: selectedDate)
            dismiss()
          } label: {
            Text("Save")
              .font(.rubikBody30)
              .foregroundColor(Color.custom.textPrimary)
              .frame(maxWidth: .infinity)
              .frame(height: 56)
              .buttonOutlineStyle()
          }
          .padding(.horizontal, 48)
          .transition(.opacity)
        }

        Spacer()
      }
    }
    .animation(.easeInOut(duration: 0.2), value: hasChanges)
  }

  /// Renders the correct `DatePicker` variant depending on whether there is a minimum date.
  @ViewBuilder
  private var minDatePicker: some View {
    if let minDate = pumpSiteManager.getPreviousSiteEndDate() {
      DatePicker(
        "",
        selection: $selectedDate,
        in: minDate...,
        displayedComponents: [.date, .hourAndMinute]
      )
      .labelsHidden()
      .datePickerStyle(.wheel)
      .padding(.horizontal, 24)
    } else {
      DatePicker(
        "",
        selection: $selectedDate,
        displayedComponents: [.date, .hourAndMinute]
      )
      .labelsHidden()
      .datePickerStyle(.wheel)
      .padding(.horizontal, 24)
    }
  }
}

// MARK: - Preview

#Preview("StartDateView") {
  let manager = PumpSiteManager()
  return NavigationStack {
    StartDateView(pumpSiteManager: manager)
      .environmentObject(manager)
  }
  .preferredColorScheme(.light)
}

#Preview("StartDateView — dark") {
  let manager = PumpSiteManager()
  return NavigationStack {
    StartDateView(pumpSiteManager: manager)
      .environmentObject(manager)
  }
  .preferredColorScheme(.dark)
}
