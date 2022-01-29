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
    
    @IBOutlet weak var progressBar: CircularProgressBar!
    
    @IBOutlet weak var newSiteButton: UIButton!
    @IBAction func newSitePressed(_ sender: Any) {
        // reset the start date & end date
        newSiteButton.isHidden = true
        newSiteButton.isEnabled = false
        showNewStartDate()
    }
    
    @IBOutlet weak var chooseStartDateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonPressed(_ sender: Any) {
        // save the current date from datepicker
        self.pumpSite.setStartDate(startDate: startDatePicker.date)
        PumpSiteManager.shared.saveToStorage(pumpSite: self.pumpSite)
        
        // show the "New site started" button & hide the rest of start date objects
        newSiteButton.isHidden = false
        newSiteButton.isEnabled = true
        hideNewStartDate()
        
        // turn the timer off
        timer?.invalidate()
        timer = nil
        
        let interval = self.pumpSite.getEndDate().timeIntervalSince(Date())
        updateProgressBar(interval: interval)
        
        // reset timer
        timeLeft = abs(Int(self.pumpSite.getEndDate().timeIntervalSince(Date())))
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButtonPressed(_ sender: Any) {
        // show the "New site started" button & hide the rest of start date objects
        newSiteButton.isHidden = false
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pumpSite = PumpSiteManager.shared.retrieveFromStorage()
        
        view.backgroundColor = UIColor.systemBackground
        setupProgressBarAppearance()
        
        timeLeft = abs(Int(self.pumpSite.getEndDate().timeIntervalSince(Date())))
        updateProgressBar(interval: Double(timeLeft))
        
        hideNewStartDate()
    }
    
    // set the current percentage and it will animate
    override func viewDidAppear(_ animated: Bool) {
        setProgressBarPercentage(animated: true)
        /*
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
        }*/
        DispatchQueue.main.asyncAfter(deadline: .now() + PROGRESS_ANIMATION_DURATION) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
        }
    }
    
    private func setupProgressBarAppearance() {
        progressBar.backgroundColor = UIColor.systemBackground
        progressBar.safePercent = 100
        progressBar.lineColor = UIColor.teal
        progressBar.lineFinishColor = .red
        progressBar.lineBackgroundColor = .gray
        progressBar.lineWidth = 20
        progressBar.wholeCircleAnimationDuration = 4
        progressBar.labelSize = 40 //this changes
        progressBar.labelFont = "DINAlternate-Bold"
    }
    
    private func updateProgressBar(interval: Double) {
        // seconds is the total seconds until pump site expires
        timeLeft = abs(Int(interval))
        
        let days = abs(Int((abs(interval) / (24.0 * 3600)).rounded(.down)))
        let intervalHours = abs(interval).truncatingRemainder(dividingBy: (24 * 3600))
        let hours = abs(Int((intervalHours / 3600).rounded(.down)))
        
        setProgressBarPercentage(animated: false)
        
        progressBar.setLabelText(days: String(days), hours: String(hours))
        
        // set day of week at top of screen
        updateNextChangeText()
    }
    
    func setProgressBarPercentage(animated: Bool) {
        // if overdue, just set the whole thing to red
        if pumpSite.isOverdue() {
            // MARK: TODO - set to red
            percent = 1
            progressBar.lineColor = .red
            progressBar.setProgress(to: percent, withAnimation: false)
        } else {
            totalSeconds = self.pumpSite.getDaysBtwn() * 86400
            percent = 1 - Double(timeLeft) / Double(totalSeconds)
            progressBar.setProgress(to: percent, withAnimation: animated)
        }
    }
    
    func updateNextChangeText() {
        endDateLabel.text = getDayOfWeek(date: self.pumpSite.getEndDate())
        
        if(pumpSite.isOverdue()) {
            nextChangeLabel.text = "LAST CHANGE WAS DUE:"
        } else {
            nextChangeLabel.text = "Next change is due"
        }
        
    }
    
    @objc func onTimerFires() {
        timeLeft = abs(Int(self.pumpSite.getEndDate().timeIntervalSince(Date())))
        updateProgressBar(interval: Double(timeLeft))
        /*
        //timeLeft -= 1
        if timeLeft > 0 {
            // find new day, minute, and hour
            
            var interval = Double(timeLeft)
            
            let days: Int = Int ((interval / (24.0 * 3600)).rounded(.down))
            interval = interval.truncatingRemainder(dividingBy: (24 * 3600))
            let hours: Int = Int ((interval / 3600).rounded(.down))
            interval = interval.truncatingRemainder(dividingBy: 3600)
            let minutes: Int = Int ((interval / 60).rounded(.down))
            
            // test if the minute, hour, or day has changed
            if(progressBar.days != String(days) || progressBar.hours != String(hours) || progressBar.minutes != String(minutes)) {
                progressBar.setLabelText(days: String(days), hours: String(hours), minutes: String(minutes))
            }
            
            // set the progress bar percentage
            percent = 1 - Double(timeLeft) / Double(totalSeconds)
            if(Double(firstTimeLeft - timeLeft) > progressBar.wholeCircleAnimationDuration) {
                progressBar.setProgress(to: percent, withAnimation: false)
            }
        }
        
        if timeLeft <= 0 {
            timePast += 1
            var interval = Double(timePast)
            
            let days: Int = Int ((interval / (24.0 * 3600)).rounded(.down))
            interval = interval.truncatingRemainder(dividingBy: (24 * 3600))
            let hours: Int = Int ((interval / 3600).rounded(.down))
            interval = interval.truncatingRemainder(dividingBy: 3600)
            let minutes: Int = Int ((interval / 60).rounded(.down))
            
            // test if the minute, hour, or day has changed
            if(progressBar.days != String(days) || progressBar.hours != String(hours) || progressBar.minutes != String(minutes)) {
                progressBar.setLabelText(days: String(days), hours: String(hours), minutes: String(minutes))
            }
            
            // set the progress bar percentage
            percent = 1 - Double(timeLeft) / Double(totalSeconds)
            if(Double(timePast - firstTimePast) > progressBar.wholeCircleAnimationDuration) {
                progressBar.setProgress(to: percent, withAnimation: false)
            }
        } */
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
    
    func getDayOfWeek(date: Date) -> String {
        let index = Calendar.current.component(.weekday, from: date)
        return Calendar.current.weekdaySymbols[index-1]
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
