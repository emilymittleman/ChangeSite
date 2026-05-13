//
//  AppState.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//

import Foundation

/// Shared observable state for the root of the app.
/// `isNewUser` drives the root-swap: when it flips to `false` the AppDelegate
/// replaces the SwiftUI onboarding hosting controller with the UIKit tab bar.
class AppState: ObservableObject {
  @Published var isNewUser: Bool

  init(isNewUser: Bool) {
    self.isNewUser = isNewUser
  }
}
