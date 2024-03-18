//
//  UserDefaultsAccessHelper.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 3/17/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import Foundation

class UserDefaultsAccessHelper {
  static let sharedInstance = UserDefaultsAccessHelper()
  private var groupUserDefaults: UserDefaults?

  private init() {}

  func setUp(withGroupID groupID: String) {
    if groupUserDefaults == nil {
      groupUserDefaults = UserDefaults(suiteName: groupID)
    }
  }

  func storeValue(_ value: Any?, withIdentifier identifier: String) {
    guard let groupUserDefaults else {
      assertionFailure("You must set up a Group ID before attempting any shared UserDefaults operations!")
      return
    }
    groupUserDefaults.set(value, forKey: identifier)
  }

  func retrieveValue(_ identifier: String) -> Any? {
    return groupUserDefaults?.object(forKey: identifier)
  }

  func retrieveValue(_ identifier: String, withDefault defaultValue: Any) -> Any {
    guard let result = groupUserDefaults?.object(forKey: identifier) else {
      return defaultValue
    }
    return result
  }

  func retrieveArray(_ identifier: String) -> [Any]? {
    return groupUserDefaults?.array(forKey: identifier)
  }

  func deleteValue(withIdentifier identifier: String) {
    guard let groupUserDefaults else {
      assertionFailure("You must set up a Group ID before attempting any shared UserDefaults operations!")
      return
    }
    groupUserDefaults.removeObject(forKey: identifier)
  }
}

