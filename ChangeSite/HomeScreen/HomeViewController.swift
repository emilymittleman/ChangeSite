//
//  LandingController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftUI

class HomeViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

  var viewModel: HomeViewModel!
  var notificationManager = NotificationManager.shared

  var timer: Timer?

  @IBOutlet weak var calendar: FSCalendar!

  @IBOutlet weak var nextChangeLabel: UILabel!
  @IBOutlet weak var countdownLabel: UILabel!

  @IBOutlet weak var newSiteButton: UIButton!
  @IBAction func newSitePressed(_ sender: Any) {
    // reset the start date & end date
    showNewStartDate()
  }

  @IBOutlet weak var chooseStartDateLabel: UILabel!
  @IBOutlet weak var saveButton: UIButton!
  @IBAction func saveButtonPressed(_ sender: Any) {
    // save the current date from datepicker
    // TODO: ensure that new startdate is not earlier than original startdate (can't go back in time)
    viewModel.endPumpSite(endDate: startDatePicker.date)
    viewModel.startNewPumpSite(startDate: startDatePicker.date)

    // show the "New site started" button & hide the rest of start date objects
    hideNewStartDate()

    // turn the timer off
    timer?.invalidate()
    timer = nil

    updateTimeLeftLabels()
    calendar.reloadData()

    // reset timer
    timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
  }

  @IBOutlet weak var cancelButton: UIButton!
  @IBAction func cancelButtonPressed(_ sender: Any) {
    // show the "New site started" button & hide the rest of start date objects
    hideNewStartDate()
  }

  @IBOutlet weak var startDatePicker: UIDatePicker!
  @IBAction func startDatePickerChanged(_ sender: Any) {
  }

  // MARK: --- Setup ---
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupCalendar()
    self.updateUI()

    // Special case: If user turned off notifications, need to reset reminders
    /* notificationManager.notificationsEnabled { enabled in
     if enabled { [weak self] in
     for reminderNotification in self.reminderNotifications {
     if reminderNotification.frequency != "none" {
     reminderNotification.frequency = "none"
     ReminderNotificationsManager.shared.mutateNotification(newReminderNotif: reminderNotification)
     notificationManager.removeAllNotifications()
     }
     }
     }
     } */
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    viewModel.updateCoreData()
    updateTimeLeftLabels()
    hideNewStartDate()
    calendar.reloadData()

  }

  private func setupCalendar() {
    calendar.frame = CGRect(x:15, y: 64, width:self.view.bounds.size.width-30, height:300)
    calendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "cell")
    // Calender actions
    calendar.allowsSelection = false
    calendar.today = Date()
    calendar.swipeToChooseGesture.isEnabled = false // Swipe-To-Choose
    calendar.scrollEnabled = false
    calendar.scope = .week
    // Calendar UI
    let mode = traitCollection.userInterfaceStyle
    calendar.appearance.headerDateFormat = ""
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.backgroundColor = UIColor.custom.background
    calendar.appearance.todayColor = UIColor.custom.lightBlue
    calendar.appearance.weekdayTextColor = UIColor.custom.lightBlue
    calendar.appearance.titleDefaultColor = UIColor.custom.textPrimary
    calendar.appearance.titleTodayColor = UIColor.custom.background
    calendar.appearance.weekdayFont = UIFont(name: "Rubik-Regular", size: 15)
    calendar.appearance.titleFont = UIFont(name: "Rubik-Regular", size: 17)
  }

  private func updateUI() {
    // deal with light and dark mode
    let mode = traitCollection.userInterfaceStyle
    view.backgroundColor = UIColor.custom.background

    nextChangeLabel.font = UIFont(name: "Rubik-Regular", size: 25)
    countdownLabel.font = UIFont(name: "Rubik-Medium", size: 40)
    newSiteButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
    chooseStartDateLabel.font = UIFont(name: "Rubik-Medium", size: 19)
    saveButton.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17)
    cancelButton.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17)

    nextChangeLabel.textColor = UIColor.custom.textPrimary
    countdownLabel.textColor = UIColor.custom.textPrimary
    chooseStartDateLabel.textColor = UIColor.custom.background
    saveButton.titleLabel?.textColor = UIColor.custom.background
    cancelButton.titleLabel?.textColor = UIColor.custom.background

    chooseStartDateLabel.backgroundColor = UIColor.custom.lightBlue
    saveButton.titleLabel?.backgroundColor = UIColor.custom.lightBlue
    cancelButton.titleLabel?.backgroundColor = UIColor.custom.lightBlue

    newSiteButton.setTitleColor(UIColor.custom.textPrimary, for: .normal)
    newSiteButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)
  }

  private func updateTimeLeftLabels() {
    nextChangeLabel.text = viewModel.getNextChangeText()
    countdownLabel.text = viewModel.getCountdownText()
    countdownLabel.textColor = viewModel.pumpSiteIsOverdue() ? UIColor.custom.redText : UIColor.custom.textPrimary

    calendar.reloadData()
  }

  @objc func onTimerFires() {
    updateTimeLeftLabels()
  }

  func hideNewStartDate() {
    // hide all buttons
    chooseStartDateLabel.isHidden = true
    saveButton.isHidden = true
    cancelButton.isHidden = true
    startDatePicker.isHidden = true
    // show New site button
    newSiteButton.isHidden = false
  }

  func showNewStartDate() {
    // show all buttons
    chooseStartDateLabel.isHidden = false
    saveButton.isHidden = false
    cancelButton.isHidden = false
    startDatePicker.isHidden = false
    // hide New site button
    newSiteButton.isHidden = true

    let pickerDate = formatDate(.now)
    startDatePicker.setDate(pickerDate, animated: true)
    //startDatePicker.minimumDate = formatDate(viewModel.pumpSiteStartDate())
  }

  // MARK: - FSCalendarDataSource

  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
    return cell
  }

  func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    self.configure(cell: cell, for: date, at: position)
  }

  // MARK: - FSCalendarDelegate

  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    self.calendar.frame.size.height = bounds.height
    // self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
  }

  // MARK: - Calendar Private functions

  private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    let cell = (cell as! CustomCalendarCell)
    // Configure symbols for change days and overdue days
    if position == .current {
      if formatCoreDataDate(viewModel.pumpSiteEndDate()) == formatCoreDataDate(date) {
        cell.selectionLayer.isHidden = false
        cell.isSelected = true
      } else {
        cell.selectionLayer.isHidden = true
        cell.isSelected = false
      }
    } else {
      cell.selectionLayer.isHidden = true
      cell.isSelected = false
    }
  }

  // MARK: - Navigation

  override func viewWillDisappear(_ animated: Bool) {
    // TODO: Make sure this gets called when user closes app
    super.viewWillDisappear(animated)
    timer?.invalidate()
    timer = nil
  }

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
  }

  class func viewController(pumpSiteManager: PumpSiteManager, remindersManager: RemindersManager) -> HomeViewController {
    let viewModel = HomeViewModel(pumpSiteManager: pumpSiteManager, remindersManager: remindersManager)
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    vc.viewModel = viewModel
    return vc
  }

}
