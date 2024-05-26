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
    saveButton.isHidden = false
  }

  @IBOutlet weak var saveButton: UIButton!
  @IBAction func saveButtonPressed(_ sender: Any) {
    // UIApplication.shared.applicationIconBadgeNumber = 0
    SiteDates.createOrUpdate(pumpSiteManager: self.pumpSiteManager, endDate: startDatePicker.date, with: coreDataStack)
    NotificationManager.shared.removeAllNotifications()

    self.pumpSiteManager.updatePumpSite(startDate: startDatePicker.date)
    SiteDates.createOrUpdate(pumpSiteManager: self.pumpSiteManager, endDate: nil, with: coreDataStack)
    coreDataStack.saveContext()
    NotificationManager.shared.scheduleNotifications(reminderTypes: ReminderType.allCases)

    performSegue(withIdentifier: "unwindStartDateToSettings", sender: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.updateUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // restrict range of startDatePicker so earliest date is current startDate

    startDatePicker.setDate(pumpSiteManager.startDate, animated: true)
    startDatePicker.minimumDate = formatDate(pumpSiteManager.startDate)
    saveButton.isHidden = true
  }

  private func updateUI() {
    // Background color
    let mode = traitCollection.userInterfaceStyle
    view.backgroundColor = UIColor.custom.background
    // Label fonts and colors
    setStartDateLabel.font = UIFont(name: "Rubik-Medium", size: 30)
    saveButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
    setStartDateLabel.textColor = UIColor.custom.textPrimary
    saveButton.setTitleColor(UIColor.custom.textPrimary, for: .normal)
    saveButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)

    // Add underline to label
    let border = UIView()
    border.backgroundColor = UIColor.custom.lightBlue
    border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    border.frame = CGRect(x: 0, y: setStartDateLabel.frame.size.height-2, width: setStartDateLabel.frame.size.width, height: 2)
    setStartDateLabel.addSubview(border)
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

}
