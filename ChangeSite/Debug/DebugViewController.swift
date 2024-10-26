//
//  DebugViewController.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 7/12/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

let defaultRowHeight = 60.0

class DebugViewController: UIViewController {

  var pumpSiteManager: PumpSiteManager!
  var remindersManager: RemindersManager!

  // Define the data model
  var data: [(key: String, value: Value)] = [
    //("Days btwn changes", .string("\(pumpSiteManager.daysBtwn)")),
    //("Toggle some value", .toggle(on: true)),
    ("Clear UserDefaults & CoreData", .button(action: {
      UserDefaultsAccessHelper.sharedInstance.clearAllData()
      SiteDatesProvider(with: AppDelegate.sharedAppDelegate.coreDataStack.managedContext).deleteAllEntries()
    })),
  ]

  enum Value {
    case string(String)
    case toggle(on: Bool)
    case button(action: () -> Void)
  }

  let tableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set up the table view
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = UIColor.custom.background

    // Create a vertical stack view to hold the buttons and the table view
    let mainStackView = UIStackView(arrangedSubviews: [tableView])
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.translatesAutoresizingMaskIntoConstraints = false

    // Add the main stack view to the view controller's view
    self.view.addSubview(mainStackView)
    self.view.backgroundColor = UIColor.custom.background

    // Set up constraints
    NSLayoutConstraint.activate([
      // Pin the main stack view to the edges of the view controller's view
      mainStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
      mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
    ])
  }

  class func viewController(pumpSiteManager: PumpSiteManager, remindersManager: RemindersManager) -> DebugViewController {
    let vc = DebugViewController()
    vc.pumpSiteManager = pumpSiteManager
    vc.remindersManager = remindersManager
    return vc
  }
}

extension DebugViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let item = data[indexPath.row]

    // Configure the cell
    cell.selectionStyle = .none
    cell.backgroundColor = UIColor.custom.background

    switch item.value {
    case .string(let value):
      cell.accessoryView = nil
      cell.textLabel?.text = item.key
      cell.detailTextLabel?.text = value
    case .toggle(let isOn):
      cell.textLabel?.text = item.key
      let toggle = UISwitch()
      toggle.isOn = isOn
      toggle.tag = indexPath.row
      toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
      cell.accessoryView = toggle
    case .button( _):
      let button = UIButton(configuration: .filled())
      button.configuration?.title = item.key
      button.configuration?.baseForegroundColor = UIColor.custom.background
      button.configuration?.baseBackgroundColor = UIColor.custom.textTertiary
      button.configuration?.cornerStyle = .medium
      button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

      button.tag = indexPath.row
      button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
      cell.contentView.addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        button.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
        button.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        //button.heightAnchor.constraint(equalToConstant: defaultRowHeight * 2/3.0),
      ])
    }

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Perform the action you want when the row is tapped
    print("Row \(indexPath.row) tapped")

    let item = data[indexPath.row]
    switch item.value {
    case .button(let action):
      action()
    default:
      break
    }
  }
}

extension DebugViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return defaultRowHeight
  }

  @objc func toggleChanged(_ sender: UISwitch) {
    let index = sender.tag
    data[index].value = .toggle(on: sender.isOn)
    print("Toggle at index \(index) changed to \(sender.isOn)")
    // TODO: perform the actual action
  }

  @objc func buttonTapped(_ sender: UIButton) {
    print("\(sender.currentTitle ?? "") tapped")
    // TODO: perform the actual action
  }
}
