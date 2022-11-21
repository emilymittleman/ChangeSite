//
//  ViewController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

// WELCOME PAGE
import UIKit

class LaunchViewController: UIViewController {
    
    var pumpSiteManager: PumpSiteManager!
    var remindersManager: RemindersManager!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var beginButton: UIButton!
    @IBAction func beginButtonTapped(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateUI()
    }
    
    private func updateUI() {
        // Background color
        let mode = traitCollection.userInterfaceStyle
        view.backgroundColor = UIColor.background(mode)
        // Label fonts
        welcomeLabel.font = UIFont(name: "Rubik-Medium", size: 45)
        beginButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 30)
        // Label colors
        welcomeLabel.textColor = UIColor.charcoal(mode)
        beginButton.setTitleColor(UIColor.charcoal(mode), for: .normal)
        beginButton.setBackgroundImage(UIImage(named: "ButtonOutline"), for: .normal)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SetupViewController {
            vc.pumpSiteManager = pumpSiteManager
            vc.remindersManager = remindersManager
        }
    }
}
