//
//  StartDateController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class StartDateController: UIViewController {

  var pumpSiteManager: PumpSiteManager!
  var coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack

  @IBOutlet weak var setStartDateLabel: UILabel!
  @IBOutlet weak var startDatePicker: UIDatePicker!
  @IBAction func startDatePickerChanged(_ sender: Any) {
    saveButton.isHidden = startDatePicker.date <= pumpSiteManager.startDate
  }

  @IBOutlet weak var saveButton: UIButton!
  @IBAction func saveButtonPressed(_ sender: Any) {
    // UIApplication.shared.applicationIconBadgeNumber = 0
    pumpSiteManager.setStartDate(startDatePicker.date)
    performSegue(withIdentifier: "unwindStartDateToSettings", sender: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.updateUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startDatePicker.setDate(pumpSiteManager.startDate, animated: true)
    startDatePicker.minimumDate = formatDate(pumpSiteManager.startDate)
    saveButton.isHidden = true
  }

  private func updateUI() {
    view.backgroundColor = UIColor.custom.background
    // Title
    setStartDateLabel.font = UIFont(name: "Rubik-Medium", size: 30)
    setStartDateLabel.textColor = UIColor.custom.textPrimary
    // Save button
    saveButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
    saveButton.setTitleColor(UIColor.custom.textPrimary, for: .normal)
    saveButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)

    // Add underline to label
    let border = UIView()
    border.backgroundColor = UIColor.custom.lightBlue
    border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    border.frame = CGRect(x: 0, y: setStartDateLabel.frame.size.height-2, width: setStartDateLabel.frame.size.width, height: 2)
    setStartDateLabel.addSubview(border)
  }

}
