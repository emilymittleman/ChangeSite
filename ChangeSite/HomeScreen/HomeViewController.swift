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

  let calendar = FSCalendar()

  @IBOutlet weak var nextChangeLabel: UILabel!
  @IBOutlet weak var countdownLabel: UILabel!

  let startDatePickerView = StartDatePickerBottomSheet()

  @IBOutlet weak var newSiteButton: UIButton!
  @IBAction func newSitePressed(_ sender: Any) {
    startDatePickerView.showInView(self.view)
  }

  // MARK: --- Setup ---
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupCalendar()
    self.setupUI()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshScreen),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didEnterBackground),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
    )

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUserTap(_:)))
    self.view.addGestureRecognizer(tapGesture)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("viewWillAppear")
    viewModel.updateCoreData()
    refreshScreen()
    restartTimer()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    print("viewWillDisappear")
    timer?.invalidate()
    timer = nil
    if (view.subviews.contains(startDatePickerView)) {
      startDatePickerView.dismiss()
    }
  }

  @objc private func didEnterBackground() {
    timer?.invalidate()
    timer = nil
  }

  @objc private func handleUserTap(_ gesture: UITapGestureRecognizer) {
    startDatePickerView.dismiss()
  }

  private func restartTimer() {
    timer?.invalidate()
    timer = nil
    timer = Timer.scheduledTimer(
      timeInterval: 60.0,
      target: self,
      selector: #selector(refreshScreen),
      userInfo: nil,
      repeats: true
    )
  }

  private func setupCalendar() {
    calendar.dataSource = self
    calendar.delegate = self
    calendar.frame = CGRect(x:15, y: 64, width:self.view.bounds.size.width-30, height:300)
    calendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "cell")
    // Calender actions
    calendar.allowsSelection = false
    calendar.today = Date()
    calendar.swipeToChooseGesture.isEnabled = false // Swipe-To-Choose
    calendar.scrollEnabled = false
    calendar.scope = .week
    // Calendar UI
    calendar.appearance.headerDateFormat = ""
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.backgroundColor = UIColor.custom.background
    calendar.appearance.todayColor = UIColor.custom.lightBlue
    calendar.appearance.weekdayTextColor = UIColor.custom.lightBlue
    calendar.appearance.titleDefaultColor = UIColor.custom.textPrimary
    calendar.appearance.titleTodayColor = UIColor.custom.background
    calendar.appearance.weekdayFont = UIFont(name: "Rubik-Regular", size: 15)
    calendar.appearance.titleFont = UIFont(name: "Rubik-Regular", size: 17)

    view.addSubview(calendar)
  }

  private func setupUI() {
    view.backgroundColor = UIColor.custom.background

    nextChangeLabel.font = UIFont(name: "Rubik-Regular", size: 25)
    nextChangeLabel.textColor = UIColor.custom.textPrimary

    countdownLabel.font = UIFont(name: "Rubik-Medium", size: 40)
    countdownLabel.textColor = UIColor.custom.textPrimary

    newSiteButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
    newSiteButton.setTitleColor(UIColor.custom.textPrimary, for: .normal)
    newSiteButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)

    // Start date picker view
    startDatePickerView.onCancel = {
      self.newSiteButton.isHidden = false
      self.startDatePickerView.dismiss()
    }
    startDatePickerView.onSave = { selectedDate in
      self.viewModel.pumpSiteManager.changedSite(changeDate: selectedDate)
      self.restartTimer()
      self.refreshScreen()
      self.newSiteButton.isHidden = false
      self.startDatePickerView.dismiss()
    }
  }

  @objc private func refreshScreen() {
    nextChangeLabel.text = viewModel.getNextChangeText()
    countdownLabel.text = viewModel.getCountdownText()
    countdownLabel.textColor = viewModel.pumpSiteIsOverdue() ? UIColor.custom.redText : UIColor.custom.textPrimary
    calendar.reloadData()
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

  class func viewController(pumpSiteManager: PumpSiteManager, remindersManager: RemindersManager) -> HomeViewController {
    let viewModel = HomeViewModel(pumpSiteManager: pumpSiteManager, remindersManager: remindersManager)
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    vc.viewModel = viewModel
    return vc
  }

}
