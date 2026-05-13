//
//  TabNavigationMenu.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/12/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

class TabNavigationMenu: UIView {

  var itemTapped: ((_ tab: Int) -> Void)?
  var activeItem: Int = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  convenience init(menuItems: [TabItem], frame: CGRect) {
    self.init(frame: frame)

    for i in 0 ..< menuItems.count {
      let itemWidth = self.frame.width / CGFloat(menuItems.count)
      let leadingAnchor = itemWidth * CGFloat(i)

      let itemView = self.createTabItem(item: menuItems[i])
      itemView.translatesAutoresizingMaskIntoConstraints = false
      itemView.clipsToBounds = true
      itemView.tag = i
      self.addSubview(itemView)

      NSLayoutConstraint.activate([
        itemView.heightAnchor.constraint(equalTo: self.heightAnchor),
        itemView.widthAnchor.constraint(equalToConstant: itemWidth), // fixing width

        itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
        itemView.topAnchor.constraint(equalTo: self.topAnchor),
      ])
    }
    self.setNeedsLayout()
    self.layoutIfNeeded()
    self.activateTab(tab: 0)
  }

  func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
    let border = UIView()
    border.backgroundColor = color
    border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
    border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
    addSubview(border)
  }

  func createTabItem(item: TabItem) -> UIView {
    let tabBarItem = UIView(frame: CGRect.zero)
    let itemTitleLabel = UILabel(frame: CGRect.zero)
    let itemIconView = UIImageView(frame: CGRect.zero)

    // adding tags to get views for modification when selected/unselected
    tabBarItem.tag = 11
    itemTitleLabel.tag = 12
    itemIconView.tag = 13

    itemTitleLabel.text = item.displayTitle
    itemTitleLabel.font = UIFont(name: "Rubik-Light", size: 12)
    itemTitleLabel.textColor = UIColor.custom.textPrimary
    itemTitleLabel.textAlignment = .center
    itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    itemTitleLabel.clipsToBounds = true

    itemIconView.image = item.icon.withRenderingMode(.alwaysTemplate)
    itemIconView.tintColor = UIColor.custom.textPrimary
    itemIconView.contentMode = .scaleAspectFill // added to stop stretching
    itemIconView.translatesAutoresizingMaskIntoConstraints = false
    itemIconView.clipsToBounds = true

    tabBarItem.layer.backgroundColor = UIColor.custom.tabBarTint.cgColor
    tabBarItem.addSubview(itemIconView)
    tabBarItem.addSubview(itemTitleLabel)
    tabBarItem.translatesAutoresizingMaskIntoConstraints = false
    tabBarItem.clipsToBounds = true

    NSLayoutConstraint.activate([
      itemIconView.heightAnchor.constraint(equalToConstant: 35),
      itemIconView.widthAnchor.constraint(equalToConstant: 35),
      itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
      itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 8),

      itemTitleLabel.topAnchor.constraint(equalTo: itemIconView.bottomAnchor),
      itemTitleLabel.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
    ])
    tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap))) // Each item should be able to trigger and action on tap
    return tabBarItem
  }

  @objc func handleTap(_ sender: UIGestureRecognizer) {
    self.deactivateTab(tab: self.activeItem)
    self.activateTab(tab: sender.view!.tag)
  }

  func activateTab(tab: Int) {
    let tabToActivate = self.subviews[tab]

    if let tabLabel = tabToActivate.viewWithTag(12) as? UILabel {
      tabLabel.textColor = UIColor.custom.textTertiary
    }
    if let tabIcon = tabToActivate.viewWithTag(13) as? UIImageView {
      tabIcon.tintColor = UIColor.custom.textTertiary
    }

    self.itemTapped?(tab)
    self.activeItem = tab
  }

  func selectTab(at index: Int) {
    guard index >= 0, index < subviews.count else { return }
    deactivateTab(tab: activeItem)
    activateTab(tab: index)
  }

  func deactivateTab(tab: Int) {
    let inactiveTab = self.subviews[tab]

    if let tabLabel = inactiveTab.viewWithTag(12) as? UILabel {
      tabLabel.textColor = UIColor.custom.textPrimary
    }
    if let tabIcon = inactiveTab.viewWithTag(13) as? UIImageView {
      tabIcon.tintColor = UIColor.custom.textPrimary
    }
  }
}
