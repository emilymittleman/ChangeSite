//
//  View+Extensions.swift
//  ChangeSiteWidgetExtension
//
//  Created by Emily Mittleman on 5/25/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
  func widgetBackground() -> some View {
    let backgroundColor = Color.custom.background
    if #available(iOS 17.0, macOS 14.0, watchOS 10.0, *) {
      return containerBackground(for: .widget) {
        backgroundColor
      }
    }
    return background(backgroundColor)
  }
}
