//
//  UserDefaultsAccessHelper.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 3/17/24.
//  Copyright © 2024 Emily Mittleman. All rights reserved.
//

import Foundation

public enum StorageKey: String {
  case newUser, startDate, daysBetween, reminders, defaultChangeTime
}

class UserDefaultsAccessHelper {
  static let sharedInstance = UserDefaultsAccessHelper()
  private var groupUserDefaults: UserDefaults?

  func setUp(withGroupID groupID: String) {
    if groupUserDefaults == nil {
      groupUserDefaults = UserDefaults(suiteName: groupID)
    }
  }

  // MARK: Setters

  func set(_ value: String?, forKey key: StorageKey) {
    storeValue(value, forKey: key)
  }

  func set(_ value: Bool?, forKey key: StorageKey) {
    storeValue(value, forKey: key)
  }

  func set(_ value: Int?, forKey key: StorageKey) {
    storeValue(value, forKey: key)
  }

  func set(_ value: Date?, forKey key: StorageKey) {
    storeValue(value, forKey: key)
  }

  func setUserFinishedSetup() {
    storeValue(false, forKey: .newUser)
  }

  func storeValue(_ value: Any?, forKey key: StorageKey) {
    guard let groupUserDefaults else {
      assertionFailure("You must set up a Group ID before attempting any shared UserDefaults operations!")
      return
    }
    groupUserDefaults.set(value, forKey: key.rawValue)
  }

  // MARK: Getters

  func string(for key: StorageKey) -> String? {
    return retrieveValue(key) as? String
  }

  func bool(for key: StorageKey) -> Bool? {
    return retrieveValue(key) as? Bool
  }

  func int(for key: StorageKey) -> Int? {
    return retrieveValue(key) as? Int
  }

  func date(for key: StorageKey) -> Date? {
    return retrieveValue(key) as? Date
  }

  func isNewUser() -> Bool {
    bool(for: .newUser) ?? true
  }

  func retrieveValue(_ key: StorageKey) -> Any? {
    return groupUserDefaults?.object(forKey: key.rawValue)
  }

  func deleteValue(withKey key: StorageKey) {
    guard let groupUserDefaults else {
      assertionFailure("You must set up a Group ID before attempting any shared UserDefaults operations!")
      return
    }
    groupUserDefaults.removeObject(forKey: key.rawValue)
  }

  #if DEBUG
  func clearAllData() {
    let dictionary = groupUserDefaults?.dictionaryRepresentation()
    dictionary?.keys.forEach { key in
      groupUserDefaults?.removeObject(forKey: key)
    }
    groupUserDefaults?.synchronize()
  }
  #endif
}

