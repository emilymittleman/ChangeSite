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
    var reminder = ( try? PropertyListDecoder().decode(Reminder.self, from: UserDefaults.standard.object(forKey: "reminder") as! Data) )!
    func saveReminder(reminder: Reminder) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(reminder), forKey: "reminder")
    }
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBAction func startDatePickerChanged(_ sender: Any) {
        reminder.startDate = startDatePicker.date
        saveReminder(reminder: reminder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        // set the actual date
        startDatePicker.setDate(reminder.startDate, animated: true)
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
