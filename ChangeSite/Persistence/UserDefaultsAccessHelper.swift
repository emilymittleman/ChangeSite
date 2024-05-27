//
//  UserDefaultsAccessHelper.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 3/17/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import Foundation

public enum StorageKey: String {
  case newUser, startDate, daysBetween, reminders
}

class UserDefaultsAccessHelper {
  static let sharedInstance = UserDefaultsAccessHelper()
  private var groupUserDefaults: UserDefaults?

  func setUp(withGroupID groupID: String) {
    if groupUserDefaults == nil {
      groupUserDefaults = UserDefaults(suiteName: groupID)
    }
  }

  func storeValue(_ value: Any?, forKey key: StorageKey) {
    guard let groupUserDefaults else {
      assertionFailure("You must set up a Group ID before attempting any shared UserDefaults operations!")
      return
    }
    groupUserDefaults.set(value, forKey: key.rawValue)
  }

  func retrieveValue(_ key: StorageKey) -> Any? {
    return groupUserDefaults?.object(forKey: key.rawValue)
  }

  func retrieveValue(_ key: StorageKey, withDefault defaultValue: Any) -> Any {
    guard let result = groupUserDefaults?.object(forKey: key.rawValue) else {
      return defaultValue
    }
    return result
  }

  func retrieveArray(_ key: StorageKey) -> [Any]? {
    return groupUserDefaults?.array(forKey: key.rawValue)
  }

  func deleteValue(withKey key: StorageKey) {
    guard let groupUserDefaults else {
      assertionFailure("You must set up a Group ID before attempting any shared UserDefaults operations!")
      return
    }
    groupUserDefaults.removeObject(forKey: key.rawValue)
  }
}

