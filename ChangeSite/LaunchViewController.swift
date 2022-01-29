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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //UserDefaults.standard.removeObject(forKey: "pumpSite")
        //UserDefaults.standard.removeObject(forKey: "reminderNotification")
        
        //UserDefaults.standard.set(true, forKey: "newUser") //testing purposes only
        
        var newUser: Bool
        /* 3 possible cases for the boolean newUser that is stored in UserDefaults:
         *    newUser = nil  ---> This means newUser has never been initiated before, so must be a new user.
         *    newUser = true ---> This means user started setup but did not finish, so they are still a new user.
         *    newUser = false --> Most common case; a user finished setup, so now they always go straight to main screen.
         */
        if UserDefaults.standard.object(forKey: "newUser") != nil {
            newUser = UserDefaults.standard.bool(forKey: "newUser")
        } else {
            newUser = true
            UserDefaults.standard.set(true, forKey: "newUser")
        }
        
        if(!newUser) { //skip welcome screen & go to landing page
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreen") as UIViewController?
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInPage
        }
    }
}

//let vc = self.storyboard?.instantiateViewController(withIdentifier: "LandingScreen") as UIViewController?
//self.show(vc!, sender: vc)
