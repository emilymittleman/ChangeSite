//
//  HomeVC.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 11/12/22.
//  Copyright © 2022 Emily Mittleman. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

  var pumpSiteManager: PumpSiteManager!

  fileprivate let gregorian = Calendar(identifier: .gregorian)
  fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  fileprivate weak var calendar: FSCalendar!
  fileprivate weak var legendView: LegendView!

  var siteDatesProvider = SiteDatesProvider(with: AppDelegate.sharedAppDelegate.coreDataStack.managedContext)
  var changedSiteDates: Set<Date?> = Set()
  var overdueDates: Set<Date?> = Set()

  override func loadView() {
    let view = UIView(frame: UIScreen.main.bounds)
    view.backgroundColor = UIColor.custom.background
    self.view = view

    let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
    let calendar = FSCalendar(frame: CGRect(x: 0, y: 64, width:self.view.bounds.size.width, height:height))
    calendar.dataSource = self
    calendar.delegate = self
    self.view.addSubview(calendar)
    self.calendar = calendar

    let legendView = LegendView(frame: CGRect(x: 0, y: 575, width:self.view.bounds.size.width, height:height/2))
    self.legendView = legendView
    self.view.addSubview(legendView)

    calendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "cell")

    // Calender actions
    calendar.allowsSelection = false
    calendar.today = .now
    calendar.swipeToChooseGesture.isEnabled = true

    // Calendar UI
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.backgroundColor = UIColor.custom.background
    calendar.appearance.todayColor = UIColor.custom.lightBlue
    calendar.appearance.weekdayTextColor = UIColor.custom.lightBlue
    calendar.appearance.titleDefaultColor = UIColor.custom.textPrimary
    calendar.appearance.headerTitleColor = UIColor.custom.textTertiary
    calendar.appearance.titleTodayColor = UIColor.custom.background

    calendar.appearance.weekdayFont = UIFont(name: "Rubik-Regular", size: 17)
    calendar.appearance.titleFont = UIFont(name: "Rubik-Regular", size: 15)
    calendar.appearance.headerTitleFont = UIFont(name: "Rubik-Regular", size: 20)

    calendar.scrollDirection = .horizontal
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.siteDatesProvider.fetchData() // optimize so only refreshes when there are updates
    self.overdueDates = siteDatesProvider.getOverdueDates()
    self.changedSiteDates = siteDatesProvider.getChangeDates()
    calendar.reloadData()
//    for site in siteDatesProvider.siteDates {
//      print(site)
//    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
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

  // MARK: - Private functions

  private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    let cell = (cell as! CustomCalendarCell)
    // Configure symbols for change days and overdue days
    if position == .current {
      if overdueDates.contains(date) {
        cell.backgroundColor = UIColor.custom.redHighlight
      } else {
        cell.backgroundColor = UIColor.clear
      }
      if changedSiteDates.contains(date) {
        cell.selectionLayer.isHidden = false
        cell.isSelected = true
      } else {
        cell.selectionLayer.isHidden = true
        cell.isSelected = false
      }
    } else {
      cell.backgroundColor = UIColor.clear
      cell.selectionLayer.isHidden = true
      cell.isSelected = false
    }
  }

  private func isDate(_ date1: Date, inSameDayAs date2: Date) -> Bool {
    return Calendar.current.startOfDay(for: date1) == Calendar.current.startOfDay(for: date2)
  }

  class func viewController(pumpSiteManager: PumpSiteManager) -> CalendarViewController {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
    vc.pumpSiteManager = pumpSiteManager
    return vc
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
