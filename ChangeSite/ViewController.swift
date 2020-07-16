//
//  ViewController.swift
//  ChangeSite2
//
//  Created by Emily Mittleman on 8/11/19.
//  Copyright © 2019 Emily Mittleman. All rights reserved.
//

// WELCOME PAGE
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var newUser: Bool
        
        UserDefaults.standard.removeObject(forKey: "reminder")
        UserDefaults.standard.removeObject(forKey: "reminderNotification")
        
        //UserDefaults.standard.set(true, forKey: "newUser")
        // if newUser exists in UserDefaults, set it, but if it's nil, then they are a new user so newUser = true
        if UserDefaults.standard.object(forKey: "newUser") != nil {
            newUser = UserDefaults.standard.bool(forKey: "newUser")
        } else {
            newUser = true
            UserDefaults.standard.set(true, forKey: "newUser")
        }
        
        if(!newUser) { //skip welcome screen & go to landing page
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "LandingScreen") as UIViewController?
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInPage
        }
    }
}

//let vc = self.storyboard?.instantiateViewController(withIdentifier: "LandingScreen") as UIViewController?
//self.show(vc!, sender: vc)
