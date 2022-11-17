//
//  StartDateController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

import UIKit

class StartDateController: UIViewController {
    
    // define reminder & saveReminder at the top of each class to use throughout (get it from UserDefaults)
    var pumpSite: PumpSite = PumpSiteManager.shared.pumpSite
    
    @IBOutlet weak var setStartDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBAction func startDatePickerChanged(_ sender: Any) {
        saveButton.isHidden = false
    }
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.pumpSite.setStartDate(startDate: startDatePicker.date)
        PumpSiteManager.shared.mutateNotification(newPumpSite: self.pumpSite)
        performSegue(withIdentifier: "unwindStartDateToSettings", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pumpSite = PumpSiteManager.shared.retrieveFromStorage()
        startDatePicker.setDate(self.pumpSite.getStartDate(), animated: true)
        saveButton.isHidden = true
    }
    
    private func updateUI() {
        // Background color
        let mode = traitCollection.userInterfaceStyle
        view.backgroundColor = UIColor.background(mode)
        // Label fonts and colors
        setStartDateLabel.font = UIFont(name: "Rubik-Medium", size: 30)
        saveButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
        setStartDateLabel.textColor = UIColor.charcoal(mode)
        saveButton.setTitleColor(UIColor.charcoal(mode), for: .normal)
        saveButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)
        
        // Add underline to label
        let border = UIView()
        border.backgroundColor = UIColor.lightBlue
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
