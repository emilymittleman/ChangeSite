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
    UserDefaults.standard.set(timePicker.date, forKey: UserDefaults.Keys.defaultChangeTime.rawValue)

    self.pumpSiteManager.updatePumpSite(changeTime: timePicker.date)
    SiteDates.createOrUpdate(pumpSiteManager: self.pumpSiteManager, endDate: nil, with: coreDataStack)
    coreDataStack.saveContext()
    // reschedule notifications
    NotificationManager.shared.removeAllNotifications()
    NotificationManager.shared.scheduleNotifications(reminderTypes: ReminderType.allCases)

    performSegue(withIdentifier: "unwindDefaultChangeTimeToSettings", sender: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.updateUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // restrict range of startDatePicker so earliest date is current startDate

    timePicker.setDate(Date(), animated: true)
    saveButton.isHidden = true
  }

  private func updateUI() {
    // Background color
    let mode = traitCollection.userInterfaceStyle
    view.backgroundColor = UIColor.background(mode)
    // Label fonts and colors
    setDefaultChangeTimeLabel.font = UIFont(name: "Rubik-Medium", size: 28)
    saveButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
    setDefaultChangeTimeLabel.textColor = UIColor.charcoal(mode)
    saveButton.setTitleColor(UIColor.charcoal(mode), for: .normal)
    saveButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)

    // Add underline to label
    let border = UIView()
    border.backgroundColor = UIColor.lightBlue
    border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    border.frame = CGRect(x: 0, y: setDefaultChangeTimeLabel.frame.size.height-2, width: setDefaultChangeTimeLabel.frame.size.width, height: 2)
    setDefaultChangeTimeLabel.addSubview(border)
  }

}
