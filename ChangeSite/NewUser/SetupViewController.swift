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
        daysBtwn.text = Int(sender.value).description //make sure can't go negative
    }
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonPressed(_ sender: Any) {
        pumpSiteManager.updatePumpSite(startDate: startDatePicker.date)
        pumpSiteManager.updatePumpSite(daysBtwnChanges: Int(stepper.value))
        // Save to CoreData
        siteDatesProvider.deleteAllEntries()
        SiteDates.createOrUpdate(pumpSiteManager: pumpSiteManager, endDate: nil, with: AppDelegate.sharedAppDelegate.coreDataStack)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
        UserDefaults.standard.set(false, forKey: "newUser")
        
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
        let pickerDate = formatDate(Date())
        startDatePicker.setDate(pickerDate, animated: true)
        daysBtwn.text = String(pumpSiteManager.daysBtwn)
        stepper.value = Double(pumpSiteManager.daysBtwn)
    }
    
    private func updateUI() {
        // Background color
        let mode = traitCollection.userInterfaceStyle
        view.backgroundColor = UIColor.background(mode)
        // Label fonts
        setStartDateLabel.font = UIFont(name: "Rubik-Medium", size: 30)
        daysBtwnLabel.font = UIFont(name: "Rubik-Medium", size: 25)
        daysBtwn.font = UIFont(name: "Rubik-Regular", size: 25)
        saveButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
        // Label colors
        setStartDateLabel.textColor = UIColor.charcoal(mode)
        daysBtwnLabel.textColor = UIColor.charcoal(mode)
        daysBtwn.textColor = UIColor.charcoal(mode)
        saveButton.setTitleColor(UIColor.charcoal(mode), for: .normal)
        saveButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)
        
        // Add underline to Set start date label
        addBottomBorderTo(setStartDateLabel)
        addBottomBorderTo(daysBtwnLabel)
    }
    
    private func addBottomBorderTo(_ label: UILabel) {
        let border = UIView()
        border.backgroundColor = UIColor.lightBlue
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: label.frame.size.height-2, width: label.frame.size.width, height: 2)
        label.addSubview(border)
    }

}
