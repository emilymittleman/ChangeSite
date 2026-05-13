//
//  Font+Rubik.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//
//  Mirrors the widget's CSFont ViewModifier for the main app target,
//  extended with Light weight and all sizes used across the app's screens.
//

import SwiftUI

// MARK: - Weight enum

extension Font {
  /// Rubik font weight variants registered in the main app bundle.
  enum RubikWeight {
    case light    // Rubik-Light
    case regular  // Rubik-Regular
    case medium   // Rubik-Medium

    var fontName: String {
      switch self {
      case .light:   return "Rubik-Light"
      case .regular: return "Rubik-Regular"
      case .medium:  return "Rubik-Medium"
      }
    }
  }

  /// Returns a Rubik font at the given size. Falls back to the system font if
  /// the named font is unavailable (e.g., in Previews before the font is loaded).
  static func rubik(_ weight: RubikWeight, _ size: CGFloat) -> Font {
    if let uiFont = UIFont(name: weight.fontName, size: size) {
      return Font(uiFont)
    }
    return .system(size: size)
  }
}

// MARK: - Named scale instances

extension Font {
  // Launch
  /// Rubik Medium 45 — launch screen H1
  static let rubikLaunchH1     = Font.rubik(.medium, 45)

  // Home countdown
  /// Rubik Medium 40 — home tab countdown label
  static let rubikCountdown    = Font.rubik(.medium, 40)

  // Section headers
  /// Rubik Medium 30 — large section header
  static let rubikHeader30     = Font.rubik(.medium, 30)
  /// Rubik Medium 28 — section header
  static let rubikHeader28     = Font.rubik(.medium, 28)
  /// Rubik Medium 26 — section header
  static let rubikHeader26     = Font.rubik(.medium, 26)
  /// Rubik Medium 25 — section header
  static let rubikHeader25     = Font.rubik(.medium, 25)

  // Body / buttons
  /// Rubik Regular 30 — large button label
  static let rubikBody30       = Font.rubik(.regular, 30)
  /// Rubik Regular 25 — body / button label
  static let rubikBody25       = Font.rubik(.regular, 25)
  /// Rubik Regular 17 — standard body text
  static let rubikBody17       = Font.rubik(.regular, 17)

  // Bottom sheet
  /// Rubik Medium 19 — bottom sheet / sheet title
  static let rubikSheetTitle   = Font.rubik(.medium, 19)

  // Tab bar
  /// Rubik Light 12 — tab bar labels
  static let rubikTabLabel     = Font.rubik(.light, 12)
}

// MARK: - ViewModifier

/// Applies a Rubik font at the specified weight and size.
struct RubikFontModifier: ViewModifier {
  let weight: Font.RubikWeight
  let size: CGFloat

  func body(content: Content) -> some View {
    content.font(.rubik(weight, size))
  }
}

// MARK: - View convenience

extension View {
  /// Applies the Rubik font at the given weight and point size.
  func rubik(_ weight: Font.RubikWeight, _ size: CGFloat) -> some View {
    modifier(RubikFontModifier(weight: weight, size: size))
  }
}
