//
//  SetupViewController.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/17/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

  var pumpSiteManager: PumpSiteManager!
  var remindersManager: RemindersManager!
  var siteDatesProvider = SiteDatesProvider(with: AppDelegate.sharedAppDelegate.coreDataStack.managedContext)

  @IBOutlet weak var setStartDateLabel: UILabel!
  @IBOutlet weak var startDatePicker: UIDatePicker!
  @IBAction func startDatePickerChanged(_ sender: Any) {
  }

  @IBOutlet weak var daysBtwnLabel: UILabel!
  @IBOutlet weak var daysBtwn: UILabel!
  @IBOutlet weak var stepper: UIStepper!
  @IBAction func stepperValueChanged(_ sender: UIStepper) {
    daysBtwn.text = Int(sender.value).description
  }

  @IBOutlet weak var saveButton: UIButton!
  @IBAction func saveButtonPressed(_ sender: Any) {
    let testing = false
    if testing {
      let components = DateComponents(calendar: .current, timeZone: .current, era: nil, year: 2022, month: 11, day: 26, hour: 16)
      let startDate = Calendar.current.date(from: components)!
      pumpSiteManager.updatePumpSite(startDate: startDate)
      pumpSiteManager.updatePumpSite(daysBtwnChanges: 3)
      // Save to CoreData
      siteDatesProvider.deleteAllEntries()
      addTestEntries()
    } else {
      pumpSiteManager.updatePumpSite(startDate: startDatePicker.date)
      pumpSiteManager.updatePumpSite(daysBtwnChanges: Int(stepper.value))
      // Save to CoreData
      siteDatesProvider.deleteAllEntries()

      SiteDates.createOrUpdate(pumpSiteManager: pumpSiteManager, endDate: nil, with: AppDelegate.sharedAppDelegate.coreDataStack)
      AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }

    AppConfig.setUserIsNotNew()

    if let navigationBaseController = self.storyboard?.instantiateViewController(withIdentifier: "navigationMenuBaseController") as? NavigationMenuBaseController {
      navigationBaseController.pumpSiteManager = self.pumpSiteManager
      navigationBaseController.remindersManager = self.remindersManager
      let appDelegate = UIApplication.shared.delegate
      appDelegate?.window??.rootViewController = navigationBaseController
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.updateUI()
    let pickerDate = formatDate(.now)
    startDatePicker.setDate(pickerDate, animated: true)
    daysBtwn.text = String(pumpSiteManager.daysBtwn)
    stepper.value = Double(pumpSiteManager.daysBtwn)
    stepper.minimumValue = 1
  }

  private func updateUI() {
    // Background color
    view.backgroundColor = UIColor.custom.background
    // Label fonts
    setStartDateLabel.font = UIFont(name: "Rubik-Medium", size: 30)
    daysBtwnLabel.font = UIFont(name: "Rubik-Medium", size: 25)
    daysBtwn.font = UIFont(name: "Rubik-Regular", size: 25)
    saveButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
    // Label colors
    setStartDateLabel.textColor = UIColor.custom.textPrimary
    daysBtwnLabel.textColor = UIColor.custom.textPrimary
    daysBtwn.textColor = UIColor.custom.textPrimary
    saveButton.setTitleColor(UIColor.custom.textPrimary, for: .normal)
    saveButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)

    // Add underline to Set start date label
    addBottomBorderTo(setStartDateLabel)
    addBottomBorderTo(daysBtwnLabel)
  }

  private func addBottomBorderTo(_ label: UILabel) {
    let border = UIView()
    border.backgroundColor = UIColor.custom.lightBlue
    border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    border.frame = CGRect(x: 0, y: label.frame.size.height-2, width: label.frame.size.width, height: 2)
    label.addSubview(border)
  }

  // MARK: Testing

  private func addTestEntries() {
    let siteData = makeTestSiteData()

    // let gregorian = Calendar(identifier: .gregorian)
    for datum in siteData {
      SiteDates.testing_addEntry(startDate: formatCoreDataDate(datum.startDate),
                                 expiredDate: formatCoreDataDate(datum.expiredDate),
                                 daysOverdue: datum.daysOverdue,
                                 with: AppDelegate.sharedAppDelegate.coreDataStack)
    }
    AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
  }

  private func makeTestSiteData() -> [TestSiteData] {
    let daysBetween = 3
    let daysOver = [0, 0, 1, 0, 0, 3, 0, 0,
                    0, 0, 0, 1, 0, 0, 3, 0, 0]
    let components = DateComponents(calendar: .current, timeZone: .current, era: nil, year: 2022, month: 10, day: 1, hour: 16)
    var startDate = Calendar.current.date(from: components)!

    var siteData: [TestSiteData] = []
    for over in daysOver {
      let testData = TestSiteData(startDate: startDate, daysBetween: daysBetween, daysOverdue: over)
      siteData.append(testData)
      startDate.addTimeInterval(TimeInterval( AppConstants.secondsPerDay * (daysBetween + over) ))
    }
    return siteData
  }
}

struct TestSiteData {
  var startDate: Date
  var expiredDate: Date
  var daysOverdue: Int
  var description: String

  init(startDate: Date, daysBetween: Int, daysOverdue: Int) {
    self.startDate = startDate
    self.expiredDate = startDate.addingTimeInterval(TimeInterval(daysBetween * AppConstants.secondsPerDay))
    self.daysOverdue = daysOverdue
    self.description = "Start: \(startDate), Expire: \(expiredDate), DaysOver: \(daysOverdue)"
  }
}
