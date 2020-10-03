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
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBAction func startDatePickerChanged(_ sender: Any) {
        self.pumpSite.startDate = startDatePicker.date
        
        PumpSiteManager.shared.mutateNotification(newPumpSite: self.pumpSite)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        self.pumpSite = PumpSiteManager.shared.retrieveFromStorage()
        
        // set the actual date
        startDatePicker.setDate(self.pumpSite.startDate, animated: true)
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
