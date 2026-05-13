//
//  CustomCalendarCell.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/12/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

enum SelectionType : Int {
  case none
  case single
}

class CustomCalendarCell: FSCalendarCell {

  weak var selectionLayer: CAShapeLayer!

  required init!(coder aDecoder: NSCoder!) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    let selectionLayer = CAShapeLayer()
    selectionLayer.fillColor = UIColor.clear.cgColor
    selectionLayer.strokeColor = UIColor.custom.textPrimary.cgColor
    selectionLayer.actions = ["hidden": NSNull()]
    self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
    self.selectionLayer = selectionLayer

    let view = UIView(frame: self.bounds)
    view.backgroundColor = UIColor.clear
    self.backgroundView = view;
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)

    let titleHeight = floor(self.contentView.fs_height*5.0/6.0)
    self.preferredTitleOffset.y = (self.contentView.fs_height - titleHeight)/2.0

    self.titleLabel.frame = CGRectMake(self.preferredTitleOffset.x, self.preferredTitleOffset.y, self.contentView.fs_width, floor(self.contentView.fs_height*5.0/6.0));

    var diameter: CGFloat = min(self.titleLabel.frame.height, self.titleLabel.frame.width)
    diameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter)*0.5) : diameter
    shapeLayer.frame = CGRectMake((self.titleLabel.frame.width-diameter)/2,
                                  self.preferredTitleOffset.y + (self.titleLabel.frame.height-diameter)/2,
                                  diameter,
                                  diameter)

    shapeLayer.path = UIBezierPath(roundedRect: shapeLayer.bounds,
                                   cornerRadius: CGRectGetWidth(shapeLayer.bounds) * 0.5).cgPath
    self.selectionLayer.frame = self.shapeLayer.frame

    if isSelected {
      selectionLayer.path = UIBezierPath(roundedRect: selectionLayer.bounds,
                                         cornerRadius: CGRectGetWidth(selectionLayer.bounds) * 0.5).cgPath
    }
  }

  override func configureAppearance() {
    super.configureAppearance()
    // Override the build-in appearance configuration
    if self.isPlaceholder {
      self.eventIndicator.isHidden = true
      self.titleLabel.textColor = UIColor.lightGray
    }
  }

}
