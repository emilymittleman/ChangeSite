//
//  DefaultChangeTimeController.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 2/13/23.
//  Copyright © 2023 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

class DefaultChangeTimeController: UIViewController {

  var pumpSiteManager: PumpSiteManager!
  var coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack

  @IBOutlet weak var setDefaultChangeTimeLabel: UILabel!
  @IBOutlet weak var timePicker: UIDatePicker!
  @IBAction func timeickerChanged(_ sender: Any) {
    saveButton.isHidden = false
  }

  @IBOutlet weak var saveButton: UIButton!
  @IBAction func saveButtonPressed(_ sender: Any) {
    // UIApplication.shared.applicationIconBadgeNumber = 0
    UserDefaultsAccessHelper.sharedInstance.set(timePicker.date, forKey: .defaultChangeTime)

    self.pumpSiteManager.setDefaultChangeTimme(timePicker.date)
    SiteDates.createOrUpdate(pumpSiteManager: self.pumpSiteManager, endDate: nil, with: coreDataStack)
    coreDataStack.saveContext()
    NotificationManager.shared.rescheduleNotifications()

    performSegue(withIdentifier: "unwindDefaultChangeTimeToSettings", sender: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.updateUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    timePicker.setDate(Date(), animated: true)
    saveButton.isHidden = true
  }

  private func updateUI() {
    view.backgroundColor = UIColor.custom.background
    // Title
    setDefaultChangeTimeLabel.font = UIFont(name: "Rubik-Medium", size: 28)
    setDefaultChangeTimeLabel.textColor = UIColor.custom.textPrimary
    // Save button
    saveButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
    saveButton.setTitleColor(UIColor.custom.textPrimary, for: .normal)
    saveButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)

    // Add underline to label
    let border = UIView()
    border.backgroundColor = UIColor.custom.lightBlue
    border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    border.frame = CGRect(x: 0, y: setDefaultChangeTimeLabel.frame.size.height-2, width: setDefaultChangeTimeLabel.frame.size.width, height: 2)
    setDefaultChangeTimeLabel.addSubview(border)
  }

}
