//
//  SettingsView.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

  // MARK: - Dependencies

  @EnvironmentObject var pumpSiteManager: PumpSiteManager
  @EnvironmentObject var remindersManager: RemindersManager

  // MARK: - Local state for the stepper

  /// Mirrors `pumpSiteManager.daysBtwn` so the stepper binding stays responsive
  /// without a published property on PumpSiteManager.
  @State private var daysBtwn: Int = 3

  // MARK: - Formatted display values

  private var formattedStartDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter.string(from: pumpSiteManager.startDate)
  }

  private var formattedDefaultChangeTime: String {
    if let time = UserDefaultsAccessHelper.sharedInstance.date(for: .defaultChangeTime) {
      let formatter = DateFormatter()
      formatter.dateStyle = .none
      formatter.timeStyle = .short
      return formatter.string(from: time)
    }
    return "Off"
  }

  // MARK: - Body

  var body: some View {
    List {
      // ---- Section 1: Pump site timing ----
      Section {
        // Start date row
        NavigationLink {
          StartDateView(pumpSiteManager: pumpSiteManager)
            .environmentObject(pumpSiteManager)
        } label: {
          HStack {
            Text("Start Date")
              .font(.rubikBody17)
              .foregroundColor(Color.custom.textPrimary)
            Spacer()
            Text(formattedStartDate)
              .font(.rubikBody17)
              .foregroundColor(Color.custom.textSecondary)
          }
        }
        .accessibilityIdentifier("settings.startDateRow")

        // Days between row — inline stepper
        HStack {
          Text("Days Between Changes")
            .font(.rubikBody17)
            .foregroundColor(Color.custom.textPrimary)
          Spacer()
          Text("\(daysBtwn)")
            .font(.rubikBody17)
            .foregroundColor(Color.custom.textSecondary)
          Stepper("", value: $daysBtwn, in: 1...30)
            .labelsHidden()
            .onChange(of: daysBtwn) { _, newValue in
              pumpSiteManager.setDaysBtwnChanges(newValue)
            }
        }
        .accessibilityIdentifier("settings.daysBetweenRow")

        // Default change time row
        NavigationLink {
          DefaultChangeTimeView()
            .environmentObject(pumpSiteManager)
        } label: {
          HStack {
            Text("Default Change Time")
              .font(.rubikBody17)
              .foregroundColor(Color.custom.textPrimary)
            Spacer()
            Text(formattedDefaultChangeTime)
              .font(.rubikBody17)
              .foregroundColor(Color.custom.textSecondary)
          }
        }
        .accessibilityIdentifier("settings.defaultChangeTimeRow")
      }
      .listRowBackground(Color.custom.background)

      // ---- Section 2: Reminders ----
      Section(header:
        Text("Reminders")
          .font(.rubikBody17)
          .foregroundColor(Color.custom.textSecondary)
      ) {
        ForEach(ReminderType.allCases, id: \.rawValue) { reminderType in
          NavigationLink {
            ReminderFrequencyView(
              reminderType: reminderType,
              remindersManager: remindersManager
            )
            .environmentObject(remindersManager)
          } label: {
            HStack {
              Text(reminderType.settingsRowTitle)
                .font(.rubikBody17)
                .foregroundColor(Color.custom.textPrimary)
              Spacer()
              Text(remindersManager.getFrequency(type: reminderType).rawValue.capitalized)
                .font(.rubikBody17)
                .foregroundColor(Color.custom.textSecondary)
            }
          }
          .accessibilityIdentifier("settings.reminder.\(reminderType.rawValue)")
        }
      }
      .listRowBackground(Color.custom.background)
    }
    .listStyle(.insetGrouped)
    .scrollContentBackground(.hidden)
    .background(Color.custom.background)
    .navigationTitle("Settings")
    .navigationBarTitleDisplayMode(.large)
    .onAppear {
      // Sync local stepper state with manager (in case another screen mutated daysBtwn).
      daysBtwn = pumpSiteManager.daysBtwn
    }
  }
}

// MARK: - ReminderType display helpers

private extension ReminderType {
  var settingsRowTitle: String {
    switch self {
    case .oneDayBefore:      return "1 Day Before"
    case .dayOf:             return "Day Of"
    case .oneDayAfter:       return "1 Day After"
    case .twoDaysAfter:      return "2 Days After"
    case .extendedDaysAfter: return "3+ Days After"
    }
  }
}

// MARK: - Preview

#Preview("SettingsView") {
  let pumpSiteManager = PumpSiteManager()
  let remindersManager = RemindersManager()
  return NavigationStack {
    SettingsView()
      .environmentObject(pumpSiteManager)
      .environmentObject(remindersManager)
  }
  .preferredColorScheme(.light)
}

#Preview("SettingsView — dark") {
  let pumpSiteManager = PumpSiteManager()
  let remindersManager = RemindersManager()
  return NavigationStack {
    SettingsView()
      .environmentObject(pumpSiteManager)
      .environmentObject(remindersManager)
  }
  .preferredColorScheme(.dark)
}
