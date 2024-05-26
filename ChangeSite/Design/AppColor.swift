//
//  AppColor.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/25/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import SwiftUI
import UIKit

extension Color {
  static let custom = Color.Custom()
  struct Custom {
    let background = Color("Background")
    let textPrimary = Color("TextPrimary")
    let textSecondary = Color("TextSecondary")
    let textTertiary = Color("TextTertiary")
    let redText = Color("RedText")
    let redHighlight = Color("RedHighlight")
    let tabBarTint = Color("TabBarTint")
    let lightBlue = Color("TextSecondary")
  }
}

extension UIColor {
  static let custom = UIColor.Custom()
  struct Custom {
//    let background = UIColor(Color.custom.background)
//    let textPrimary = UIColor(Color.custom.textPrimary)
//    let textSecondary = UIColor(Color.custom.textSecondary)
//    let textTertiary = UIColor(Color.custom.textTertiary)
//    let redText = UIColor(Color.custom.redText)
//    let redHighlight = UIColor(Color.custom.redHighlight)
//    let tabBarTint = UIColor(Color.custom.tabBarTint)
//    let lightBlue = UIColor(Color.custom.lightBlue)
    let background = UIColor(named: "Background") ?? UIColor.black
    let textPrimary = UIColor(named: "TextPrimary") ?? UIColor.black
    let textSecondary = UIColor(named: "TextSecondary") ?? UIColor.black
    let textTertiary = UIColor(named: "TextTertiary") ?? UIColor.black
    let redText = UIColor(named: "RedText") ?? UIColor.black
    let redHighlight = UIColor(named: "RedHighlight") ?? UIColor.black
    let tabBarTint = UIColor(named: "TabBarTint") ?? UIColor.black
    let lightBlue = UIColor(named: "TextSecondary") ?? UIColor.black
  }
}
