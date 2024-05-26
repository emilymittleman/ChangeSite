//
//  CSFont.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 1/23/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import SwiftUI

public struct CSFont: ViewModifier {

  public static let H1 = CSFont(fontSize: 32)
  public static let H2 = CSFont(fontSize: 24)
  public static let H3 = CSFont(fontSize: 20)
  public static let H4 = CSFont(fontSize: 18)
  public static let H5 = CSFont(fontSize: 16)
  public static let BodyLabel = CSFont(fontSize: 14)
  public static let CaptionLabel = CSFont(fontSize: 12)

  public let fontSize: CGFloat

  public init(fontSize: CGFloat) {
    self.fontSize = fontSize
  }

  var font: Font {
    if let rubik = UIFont(name: "Rubik-Regular", size: fontSize) {
      return Font(rubik)
    }
    return .system(size: fontSize)
  }

  public func body(content: Content) -> some View {
    content
      .font(font)
  }
}

extension View {
  public func cs(font: CSFont) -> some View {
    modifier(font)
  }
}

