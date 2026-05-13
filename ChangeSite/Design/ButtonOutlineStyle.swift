//
//  ButtonOutlineStyle.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/12/26.
//  Copyright © 2026 Emily Mittleman. All rights reserved.
//
//  Replicates the ButtonOutline image asset (a rounded-rect stroke in
//  TextSecondary / light-blue) as a SwiftUI ViewModifier.
//
//  The source image shows a capsule-style rounded rectangle with:
//    - A continuous, large corner radius (visually near-capsule)
//    - A ~1.5 pt stroke in the app's TextSecondary (light blue) color
//    - No fill
//

import SwiftUI

// MARK: - ViewModifier

/// Applies the ButtonOutline appearance: a rounded-rectangle stroke border
/// matching the `ButtonOutline` image asset used by UIKit screens.
struct ButtonOutlineStyle: ViewModifier {
  /// Corner radius that matches the visual appearance of the ButtonOutline asset.
  /// The image uses a near-capsule radius; 28 pt gives a pill shape on standard button heights.
  var cornerRadius: CGFloat = 28
  /// Stroke width matching the image asset border weight.
  var lineWidth: CGFloat = 1.5

  func body(content: Content) -> some View {
    content
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .strokeBorder(Color.custom.textSecondary, lineWidth: lineWidth)
      )
  }
}

// MARK: - View convenience

extension View {
  /// Applies the ButtonOutline stroke border (rounded rectangle, TextSecondary color).
  func buttonOutlineStyle(cornerRadius: CGFloat = 28, lineWidth: CGFloat = 1.5) -> some View {
    modifier(ButtonOutlineStyle(cornerRadius: cornerRadius, lineWidth: lineWidth))
  }
}

// MARK: - Preview

#Preview("ButtonOutlineStyle") {
  VStack(spacing: 24) {
    Text("Changed Site")
      .rubik(.regular, 30)
      .foregroundColor(Color.custom.textPrimary)
      .frame(maxWidth: .infinity)
      .frame(height: 56)
      .buttonOutlineStyle()
      .padding(.horizontal, 32)

    Text("Save")
      .rubik(.regular, 17)
      .foregroundColor(Color.custom.textPrimary)
      .frame(width: 120, height: 44)
      .buttonOutlineStyle(cornerRadius: 22)
  }
  .padding()
  .background(Color.custom.background)
}
