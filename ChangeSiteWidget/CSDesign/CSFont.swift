//
//  CSFont.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 1/23/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import SwiftUI

public struct CSFont: ViewModifier {

  public static let H1 = CSFont(fontSize: 32, lineHeight: 36)
  public static let H2 = CSFont(fontSize: 24, lineHeight: 28)
  public static let H3 = CSFont(fontSize: 20, lineHeight: 24)
  public static let H4 = CSFont(fontSize: 18, lineHeight: 24)
  public static let H5 = CSFont(fontSize: 16, lineHeight: 24)
  public static let BodyLabel = CSFont(fontSize: 14, lineHeight: 20)
  public static let CaptionLabel = CSFont(fontSize: 12, lineHeight: 16)
  public static let Link = CSFont(fontSize: 14, lineHeight: 20)

  public let fontSize: CGFloat
  public let lineHeight: CGFloat

  public init(fontSize: CGFloat, lineHeight: CGFloat = 0) {
    self.fontSize = fontSize
    self.lineHeight = lineHeight == 0 ? fontSize : lineHeight
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

