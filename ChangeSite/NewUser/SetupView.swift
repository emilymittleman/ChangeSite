//
//  SetupView.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//
//  SwiftUI replacement for SetupViewController.
//  Pushed onto the NavigationStack from LaunchView.
//

import SwiftUI

struct SetupView: View {

  @EnvironmentObject var pumpSiteManager: PumpSiteManager
  @EnvironmentObject var remindersManager: RemindersManager
  @EnvironmentObject var appState: AppState

  // Mirror SetupViewController: init picker from formatDate(.now)
  @State private var startDate: Date = formatDate(.now)
  // Init stepper value from pumpSiteManager.daysBtwn via onAppear
  @State private var daysBtwn: Int = 3

  var body: some View {
    ZStack {
      Color.custom.background
        .ignoresSafeArea()

      VStack(alignment: .leading, spacing: 40) {
        Spacer()
          .frame(height: 16)

        // MARK: Start date section
        VStack(alignment: .leading, spacing: 16) {
          Text("Set start date")
            .font(.rubikHeader30)
            .foregroundColor(Color.custom.textPrimary)
            .overlay(alignment: .bottom) {
              Rectangle()
                .fill(Color.custom.lightBlue)
                .frame(height: 2)
            }

          DatePicker(
            "",
            selection: $startDate,
            displayedComponents: [.date, .hourAndMinute]
          )
          .labelsHidden()
          .accessibilityIdentifier("setupDatePicker")
        }
        .padding(.horizontal, 32)

        // MARK: Days between section
        VStack(alignment: .leading, spacing: 16) {
          Text("Days between changes")
            .font(.rubikHeader25)
            .foregroundColor(Color.custom.textPrimary)
            .overlay(alignment: .bottom) {
              Rectangle()
                .fill(Color.custom.lightBlue)
                .frame(height: 2)
            }

          HStack {
            Text("\(daysBtwn)")
              .font(.rubikBody25)
              .foregroundColor(Color.custom.textPrimary)
              .frame(minWidth: 32, alignment: .leading)

            Stepper("", value: $daysBtwn, in: 1...Int.max)
              .labelsHidden()
              .accessibilityIdentifier("setupStepper")
          }
        }
        .padding(.horizontal, 32)

        Spacer()

        // MARK: Save button
        Button {
          saveAndFinish()
        } label: {
          Text("Save")
            .font(.rubikBody30)
            .foregroundColor(Color.custom.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
        }
        .buttonOutlineStyle()
        .padding(.horizontal, 48)
        .accessibilityIdentifier("setupSaveButton")

        Spacer()
          .frame(height: 40)
      }
    }
    .navigationBarBackButtonHidden(false)
    .onAppear {
      daysBtwn = pumpSiteManager.daysBtwn
    }
  }

  // MARK: - Actions

  private func saveAndFinish() {
    pumpSiteManager.setStartDate(startDate)
    pumpSiteManager.setDaysBtwnChanges(daysBtwn)
    UserDefaultsAccessHelper.sharedInstance.setUserFinishedSetup()
    // Triggers AppDelegate to swap the root VC to the main tab bar
    appState.isNewUser = false
  }
}

#Preview {
  NavigationStack {
    SetupView()
      .environmentObject(PumpSiteManager())
      .environmentObject(RemindersManager())
      .environmentObject(AppState(isNewUser: true))
  }
}
