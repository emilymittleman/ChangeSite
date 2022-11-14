//
//  LandingController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var pumpSite: PumpSite = PumpSiteManager.shared.pumpSite
    var reminderNotifications: [ReminderNotification] = ReminderNotificationsManager.shared.reminderNotifications
    var notificationManager = NotificationManager.shared
    var coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
    var siteDatesProvider = SiteDatesProvider(with: AppDelegate.sharedAppDelegate.coreDataStack.managedContext)
    
    // var timer: Timer
    var firstTimeLeft = 0
    var timeLeft = 0 //only a positive int ///isn't actually being used for anything rn
    var firstTimePast = 0
    var timePast = 0
    var timer:Timer?
    
    var totalSeconds:Int = 0
    var percent:Double = 0.5
    
    @IBOutlet weak var nextChangeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var newSiteButtonOutline: UIImageView!
    @IBOutlet weak var newSiteButton: UIButton!
    @IBAction func newSitePressed(_ sender: Any) {
        // reset the start date & end date
        newSiteButton.isHidden = true
        newSiteButtonOutline.isHidden = true
        newSiteButton.isEnabled = false
        showNewStartDate()
    }
    
    @IBOutlet weak var chooseStartDateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonPressed(_ sender: Any) {
        // save the current date from datepicker
        // TODO: ensure that new startdate is not earlier than original startdate (can't go back in time)
        SiteDates.createOrUpdate(pumpSite: pumpSite, endDate: startDatePicker.date, with: coreDataStack)
        
        self.pumpSite.setStartDate(startDate: startDatePicker.date)
        PumpSiteManager.shared.saveToStorage(pumpSite: self.pumpSite)
        SiteDates.createOrUpdate(pumpSite: pumpSite, endDate: nil, with: coreDataStack)
        coreDataStack.saveContext()
        
        // show the "New site started" button & hide the rest of start date objects
        newSiteButton.isHidden = false
        newSiteButtonOutline.isHidden = false
        newSiteButton.isEnabled = true
        hideNewStartDate()
        
        // turn the timer off
        timer?.invalidate()
        timer = nil
        
        let interval = self.pumpSite.getEndDate().timeIntervalSince(Date())
        updateDates(interval: interval)
        
        // reset timer
        timeLeft = abs(Int(self.pumpSite.getEndDate().timeIntervalSince(Date())))
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButtonPressed(_ sender: Any) {
        // show the "New site started" button & hide the rest of start date objects
        newSiteButton.isHidden = false
        newSiteButtonOutline.isHidden = false
        newSiteButton.isEnabled = true
        hideNewStartDate()
    }
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBAction func startDatePickerChanged(_ sender: Any) {
    }
    
    // MARK: ------- Setup -------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if this view has ever loaded, then newUser = false
        UserDefaults.standard.set(false, forKey: "newUser")
        
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
        
        self.updateUI()
        
        self.pumpSite = PumpSiteManager.shared.retrieveFromStorage()
        updateDatabase()
        let interval = self.pumpSite.getEndDate().timeIntervalSince(Date())
        timeLeft = abs(Int(interval))
        updateDates(interval: interval)
        hideNewStartDate()
    }
    
    private func updateDatabase() {
        // if daysBtwn has changed, update CoreData expiredDate & daysOverdue accordingly
        // if current site is overdue AND coredata.overdue != current overdue days, update CoreData
        guard let currentSite = siteDatesProvider.getCurrentSite() else {
            print("Database error: could not retrieve current site")
            return
        }
        
        // check daysOverdue (daysOverdue & expiredDate will be updated if daysBtwn changed)
        if pumpSite.isOverdue() {
            let daysOver = Calendar.current.dateComponents([.day], from: pumpSite.getEndDate(), to: Date()).day ?? 0
            if daysOver != currentSite.daysOverdue {
                SiteDates.createOrUpdate(pumpSite: pumpSite, endDate: nil, with: coreDataStack)
            }
        }
        // if not overdue, still check if daysBtwn changed so expiredDate needs to be updated
        else {
            if formatSiteDate(pumpSite.getEndDate()) != currentSite.expiredDate {
                SiteDates.createOrUpdate(pumpSite: pumpSite, endDate: nil, with: coreDataStack)
            }
        }
    }
    
    private func updateUI() {
        // deal with light and dark mode
        let mode = traitCollection.userInterfaceStyle
        view.backgroundColor = UIColor.background(mode)
        
        nextChangeLabel.font = UIFont(name: "Rubik-Regular", size: 25)
        endDateLabel.font = UIFont(name: "Rubik-Bold", size: 40)
        newSiteButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
        chooseStartDateLabel.font = UIFont(name: "Rubik-Medium", size: 19)
        saveButton.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17)
        cancelButton.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17)
        
        nextChangeLabel.textColor = UIColor.charcoal(mode)
        endDateLabel.textColor = UIColor.charcoal
        newSiteButton.titleLabel?.textColor = UIColor.charcoal
        chooseStartDateLabel.textColor = UIColor.charcoal
        saveButton.titleLabel?.textColor = UIColor.charcoal
        cancelButton.titleLabel?.textColor = UIColor.charcoal
        
        chooseStartDateLabel.backgroundColor = UIColor.lightBlue
        saveButton.titleLabel?.backgroundColor = UIColor.lightBlue
        cancelButton.titleLabel?.backgroundColor = UIColor.lightBlue
    }
    
    private func updateDates(interval: Double) {
        // seconds is the total seconds until pump site expires
        timeLeft = abs(Int(interval))
        var days: Int
        
        let month = Calendar.current.component(.month, from: self.pumpSite.getEndDate())
        if month == Calendar.current.component(.month, from: Date()) {
            let siteDay = Calendar.current.component(.day, from: self.pumpSite.getEndDate())
            let currentDay = Calendar.current.component(.day, from: Date())
            days = abs(siteDay - currentDay)
        }
        else {
            days = abs(Int((abs(interval) / (24.0 * 3600)).rounded(.up)))
        }
        
        // update labels
        if(pumpSite.isOverdue()) {
            nextChangeLabel.text = "Change was due " + getDateAbbr(date: self.pumpSite.getEndDate())
            endDateLabel.text = String(days) + " DAYS LATE"
            if(days==1) {
                endDateLabel.text = String(days) + " DAY LATE"
            }
            endDateLabel.textColor = .red
        } else {
            nextChangeLabel.text = "Next change is due " + getDateAbbr(date: self.pumpSite.getEndDate())
            endDateLabel.text = String(days) + " Days Left"
            if(days==1) {
                endDateLabel.text = String(days) + " Day Left"
            }
            endDateLabel.textColor = UIColor.charcoal
        }
    }
    
    @objc func onTimerFires() {
        let interval = self.pumpSite.getEndDate().timeIntervalSince(Date())
        timeLeft = abs(Int(interval))
        updateDates(interval: interval)
    }
    
    
    func hideNewStartDate() {
        // hide all buttons
        chooseStartDateLabel.isHidden = true
        saveButton.isHidden = true
        cancelButton.isHidden = true
        startDatePicker.isHidden = true
        // disable all buttons
        cancelButton.isEnabled = false
        saveButton.isEnabled = false
        startDatePicker.isEnabled = false
    }
    
    func showNewStartDate() {
        // show all buttons
        chooseStartDateLabel.isHidden = false
        saveButton.isHidden = false
        cancelButton.isHidden = false
        startDatePicker.isHidden = false
        // enables all buttons
        cancelButton.isEnabled = true
        saveButton.isEnabled = true
        startDatePicker.isEnabled = true
        
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let minutesQuarter = Int(floor(Double(minutes)/15.0) * 15) % 60
        let startingDate = Calendar.current.date(bySettingHour: hours, minute: minutesQuarter, second: 0, of: date)!
        startDatePicker.setDate(startingDate, animated: true)
    }
    
    func getDateAbbr(date: Date) -> String {
        /*
        let index = Calendar.current.component(.weekday, from: date)
        let abbrevs = ["Jan", "Feb", "March", "April", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]
        return abbrevs[index-1] + " " + String(Calendar.current.component(.day, from: date)) */
        return date.dayOfWeek() ?? ""
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    class func viewController() -> HomeViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    

}
