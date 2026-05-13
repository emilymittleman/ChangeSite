//
//  DefaultChangeTimeView.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//

import SwiftUI

struct DefaultChangeTimeView: View {

  @EnvironmentObject var pumpSiteManager: PumpSiteManager
  @Environment(\.dismiss) private var dismiss

  @State private var selectedTime: Date
  private let originalTime: Date

  init() {
    let stored = UserDefaultsAccessHelper.sharedInstance.date(for: .defaultChangeTime) ?? .now
    self.originalTime = stored
    _selectedTime = State(initialValue: stored)
  }

  private var hasChanges: Bool {
    !Calendar.current.isDate(selectedTime, equalTo: originalTime, toGranularity: .minute)
  }

  var body: some View {
    ZStack(alignment: .top) {
      Color.custom.background
        .ignoresSafeArea()

      VStack(spacing: 32) {
        // Title with lightBlue bottom underline
        VStack(alignment: .leading, spacing: 0) {
          Text("Set Default Change Time")
            .font(.rubikHeader28)
            .foregroundColor(Color.custom.textPrimary)

          Rectangle()
            .fill(Color.custom.lightBlue)
            .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.top, 24)

        DatePicker(
          "",
          selection: $selectedTime,
          displayedComponents: .hourAndMinute
        )
        .labelsHidden()
        .datePickerStyle(.wheel)
        .padding(.horizontal, 24)

        if hasChanges {
          Button {
            pumpSiteManager.setDefaultChangeTimme(selectedTime)
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
}

// MARK: - Preview

#Preview("DefaultChangeTimeView") {
  let manager = PumpSiteManager()
  return NavigationStack {
    DefaultChangeTimeView()
      .environmentObject(manager)
  }
  .preferredColorScheme(.light)
}

#Preview("DefaultChangeTimeView — dark") {
  let manager = PumpSiteManager()
  return NavigationStack {
    DefaultChangeTimeView()
      .environmentObject(manager)
  }
  .preferredColorScheme(.dark)
}
