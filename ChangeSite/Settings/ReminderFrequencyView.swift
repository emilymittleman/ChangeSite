//
//  ReminderFrequencyView.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//

import SwiftUI
import UserNotifications

struct ReminderFrequencyView: View {

  // MARK: - Dependencies

  @EnvironmentObject var remindersManager: RemindersManager
  @Environment(\.dismiss) private var dismiss

  let reminderType: ReminderType

  // MARK: - State

  @State private var selectedFrequency: ReminderFrequency
  @State private var soundOn: Bool
  @State private var repeatingTime: Date
  @State private var showNotificationsAlert = false
  @State private var hasChanges = false

  // Tracks the values at init so we can detect changes.
  private let originalFrequency: ReminderFrequency
  private let originalSoundOn: Bool
  private let originalRepeatingTime: Date

  // MARK: - Init

  init(reminderType: ReminderType, remindersManager: RemindersManager) {
    self.reminderType = reminderType
    let freq = remindersManager.getFrequency(type: reminderType)
    let sound = remindersManager.getSoundOn(type: reminderType)
    let repeating = remindersManager.getRepeatingFrequency(type: reminderType)
    self.originalFrequency = freq
    self.originalSoundOn = sound
    self.originalRepeatingTime = repeating
    _selectedFrequency = State(initialValue: freq)
    _soundOn = State(initialValue: sound)
    _repeatingTime = State(initialValue: repeating)
  }

  // MARK: - Body

  var body: some View {
    ZStack(alignment: .top) {
      Color.custom.background
        .ignoresSafeArea()

      VStack(alignment: .leading, spacing: 32) {
        // Title with lightBlue bottom underline
        VStack(alignment: .leading, spacing: 0) {
          Text(reminderType.displayTitle)
            .font(.rubikHeader30)
            .foregroundColor(Color.custom.textPrimary)

          Rectangle()
            .fill(Color.custom.lightBlue)
            .frame(height: 2)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)

        // Frequency picker (segmented)
        Picker("Frequency", selection: $selectedFrequency) {
          Text(ReminderFrequency.none.rawValue.capitalized)
            .tag(ReminderFrequency.none)
          Text(ReminderFrequency.single.rawValue.capitalized)
            .tag(ReminderFrequency.single)
          Text(ReminderFrequency.repeating.rawValue.capitalized)
            .tag(ReminderFrequency.repeating)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 24)
        .onChange(of: selectedFrequency) { _, newValue in
          handleFrequencyChange(newValue)
        }

        // Sound toggle — visible when frequency != .none
        if selectedFrequency != .none {
          HStack {
            Text("Sound")
              .font(.rubikHeader26)
              .foregroundColor(Color.custom.textPrimary)

            Spacer()

            Toggle("", isOn: $soundOn)
              .labelsHidden()
              .onChange(of: soundOn) { _, _ in
                hasChanges = true
              }
          }
          .padding(.horizontal, 24)
          .transition(.opacity)
        }

        // Repeating interval picker — visible only when frequency == .repeating
        if selectedFrequency == .repeating {
          VStack(alignment: .leading, spacing: 8) {
            Text("Remind me every")
              .font(.rubikHeader26)
              .foregroundColor(Color.custom.textPrimary)
              .padding(.horizontal, 24)

            DatePicker(
              "",
              selection: $repeatingTime,
              displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .datePickerStyle(.wheel)
            .padding(.horizontal, 24)
            .onChange(of: repeatingTime) { _, _ in
              hasChanges = true
            }
          }
          .transition(.opacity)
        }

        // Save button — visible when any value has changed
        if hasChanges {
          Button {
            saveAndDismiss()
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
    .animation(.easeInOut(duration: 0.2), value: selectedFrequency)
    .animation(.easeInOut(duration: 0.2), value: hasChanges)
    .alert("Enable Notifications", isPresented: $showNotificationsAlert) {
      Button("Cancel", role: .cancel) { }
      Button("Settings") {
        if let url = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(url)
        }
      }
    } message: {
      Text("In order to set up reminders, please go to settings to enable notifications.")
    }
    .onAppear {
      NotificationManager.shared.fetchNotificationSettings()
    }
  }

  // MARK: - Private helpers

  private func handleFrequencyChange(_ newFrequency: ReminderFrequency) {
    guard newFrequency != .none else {
      // Moving to .none is always allowed.
      hasChanges = true
      return
    }

    // Check if notifications are enabled before allowing a non-none selection.
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      DispatchQueue.main.async {
        if settings.authorizationStatus == .authorized {
          hasChanges = true
        } else {
          // Revert the picker and show the alert.
          selectedFrequency = originalFrequency == .none ? .none : originalFrequency
          showNotificationsAlert = true
        }
      }
    }
  }

  private func saveAndDismiss() {
    // Normalize the repeating time to zero seconds (mirrors the UIKit getRepeatingFromDatePicker logic).
    let hours = Calendar.current.component(.hour, from: repeatingTime)
    let minutes = Calendar.current.component(.minute, from: repeatingTime)
    let normalizedRepeating = Calendar.current.date(
      bySettingHour: hours, minute: minutes, second: 0, of: .now
    ) ?? repeatingTime

    remindersManager.updateReminder(type: reminderType, frequency: selectedFrequency)
    remindersManager.updateReminder(type: reminderType, soundOn: soundOn)
    remindersManager.updateReminder(type: reminderType, repeatingFrequency: normalizedRepeating)
    NotificationManager.shared.rescheduleNotifications([reminderType])
    dismiss()
  }
}

// MARK: - ReminderType display helpers

private extension ReminderType {
  var displayTitle: String {
    switch self {
    case .oneDayBefore:    return "1 Day Before"
    case .dayOf:           return "Day Of"
    case .oneDayAfter:     return "1 Day After"
    case .twoDaysAfter:    return "2 Days After"
    case .extendedDaysAfter: return "3+ Days After"
    }
  }
}

// MARK: - Preview

#Preview("ReminderFrequencyView — dayOf") {
  let remindersManager = RemindersManager()
  return NavigationStack {
    ReminderFrequencyView(reminderType: .dayOf, remindersManager: remindersManager)
      .environmentObject(remindersManager)
  }
  .preferredColorScheme(.light)
}

#Preview("ReminderFrequencyView — repeating") {
  let remindersManager = RemindersManager()
  remindersManager.updateReminder(type: .oneDayAfter, frequency: .repeating)
  return NavigationStack {
    ReminderFrequencyView(reminderType: .oneDayAfter, remindersManager: remindersManager)
      .environmentObject(remindersManager)
  }
  .preferredColorScheme(.dark)
}
