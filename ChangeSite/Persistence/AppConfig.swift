//
//  AppConfig.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 5/25/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import Foundation

class AppConfig {
  
  static func isNewUser() -> Bool {
    UserDefaultsAccessHelper.sharedInstance.retrieveValue(StorageKey.newUser) as? Bool ?? true
  }
  
  static func setUserIsNotNew() {
    UserDefaultsAccessHelper.sharedInstance.storeValue(false, forKey: StorageKey.newUser)
  }
}

