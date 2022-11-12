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
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate weak var calendar: FSCalendar!
    
    // var siteDates = [SiteDates]()
    var siteDatesProvider = SiteDatesProvider(with: AppDelegate.sharedAppDelegate.coreDataStack.managedContext)
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        let mode = traitCollection.userInterfaceStyle
        view.backgroundColor = UIColor.background(mode)
        self.view = view
        
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 64, width:self.view.bounds.size.width, height:height))
        calendar.dataSource = self
        calendar.delegate = self
        self.view.addSubview(calendar)
        self.calendar = calendar
        
        calendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "cell")
        
        // Calender actions
        calendar.allowsSelection = false
        calendar.today = Date()
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        // Calendar UI
        calendar.backgroundColor = UIColor.white
        calendar.appearance.todayColor = UIColor.lightBlue
        calendar.appearance.weekdayTextColor = UIColor.lightBlue
        calendar.appearance.titleDefaultColor = UIColor.charcoal
        
        calendar.appearance.weekdayFont = UIFont(name: "Rubik-Regular", size: 17)
        calendar.appearance.titleFont = UIFont(name: "Rubik-Regular", size: 15)
        calendar.appearance.headerTitleFont = UIFont(name: "Rubik-Regular", size: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.siteDatesProvider.fetchData() // optimize so only refreshes when there are updates
        
        let siteDates = siteDatesProvider.siteDates
        print(siteDates)
        
        //updateUIRanges()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FSCalendar"
    }
    
    func updateUIRanges() {
        print(calendar.visibleCells())
    }
    
    // MARK: - FSCalendarDataSource
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("page changing!")
        updateUIRanges()
    }
    
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
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let cell = (cell as! CustomCalendarCell)
        // Custom today circle
        if cell.dateIsToday {
            cell.shapeLayer.isHidden = false
        }
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            
            let siteDates = siteDatesProvider.siteDates
            // print(siteDates)
            // siteDates[1].
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                cell.selectionLayer.isHidden = true
                return
            }
            cell.selectionLayer.isHidden = false
            cell.selectionType = selectionType
            
        } else {
            //cell.circleImageView.isHidden = true
            cell.selectionLayer.isHidden = true
        }
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
