//
//  LaunchView.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//
//  SwiftUI replacement for LaunchViewController.
//  Displayed via UIHostingController when the user is new.
//

import SwiftUI

struct LaunchView: View {

  @EnvironmentObject var pumpSiteManager: PumpSiteManager
  @EnvironmentObject var remindersManager: RemindersManager

  @State private var showSetup = false

  var body: some View {
    NavigationStack {
      ZStack {
        Color.custom.background
          .ignoresSafeArea()

        VStack {
          Spacer()

          Text("Welcome to ChangeSite")
            .font(.rubikLaunchH1)
            .foregroundColor(Color.custom.textPrimary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)

          Spacer()

          Button {
            showSetup = true
          } label: {
            Text("Begin")
              .font(.rubikBody30)
              .foregroundColor(Color.custom.textPrimary)
              .frame(maxWidth: .infinity)
              .frame(height: 64)
          }
          .buttonOutlineStyle()
          .padding(.horizontal, 48)
          .accessibilityIdentifier("beginButton")

          Spacer()
            .frame(height: 60)
        }
      }
      .navigationDestination(isPresented: $showSetup) {
        SetupView()
      }
    }
  }
}

#Preview {
  LaunchView()
    .environmentObject(PumpSiteManager())
    .environmentObject(RemindersManager())
}
