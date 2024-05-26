//
//  LegendView.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/27/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import UIKit

class LegendView: UIView {

  @IBOutlet var contentView: UIView!

  @IBOutlet weak var todayIcon: UIImageView!
  @IBOutlet weak var todayLabel: UILabel!

  @IBOutlet weak var changeDateIcon: UIImageView!
  @IBOutlet weak var changeDateLabel: UILabel!

  @IBOutlet weak var overdueIcon: UIImageView!
  @IBOutlet weak var overdueLabel: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    initSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initSubviews() {
    let nib = UINib(nibName: "LegendView", bundle: nil)
    nib.instantiate(withOwner: self)
    contentView.frame = bounds
    setUIAppearance(with: .light)
    setConstraints()
    addSubview(contentView)
  }

  func setUIAppearance(with mode: UIUserInterfaceStyle) {
    self.backgroundColor = UIColor.custom.background
    contentView.backgroundColor = UIColor.custom.background
    todayIcon.tintColor = UIColor.custom.lightBlue
    changeDateIcon.tintColor = UIColor.custom.textPrimary
    overdueIcon.tintColor = UIColor.custom.redHighlight

    let labels: [UILabel] = [todayLabel, changeDateLabel, overdueLabel]
    for label in labels {
      label.textColor = UIColor.custom.textPrimary
      label.font = UIFont(name: "Rubik-Regular", size: 17)
    }
  }

  private func setConstraints() {
    // TODO: Add constraints programatically (translate and modify xib constraints)
  }

}
