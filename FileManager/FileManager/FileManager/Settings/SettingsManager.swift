//
//  SettingsManager.swift
//  FileManager
//
//  Created by Helen Gokun on 30.03.2021.
//

import Foundation
import UIKit

class SettingsManager {
  static let shared = SettingsManager()
  
  private let colorSchemeKey = "COLOR_SHEME"
  private let hideThumbsKey = "HIDE_IMAGE_PREVIEW"
  private let sortByKey = "SORT_BY"
  
  let numOfColorSchmes = 3
  
  private var color: ColorScheme
  var colorScheme: ColorScheme {
    set {
      self.color = newValue
      UserDefaults.standard.setValue(newValue.rawValue, forKey: colorSchemeKey)
    }
    get {
      return color
    }
  }
  
  var hideThumbs: Bool {
    get {
      UserDefaults.standard.bool(forKey: hideThumbsKey)
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: hideThumbsKey)
    }
  }
  
  var sortBy: SortBy {
    get {
      let sort = UserDefaults.standard.integer(forKey: sortByKey)
      if let sorting = SortBy(rawValue: sort) {
        return sorting
      } else {
        UserDefaults.standard.setValue(0, forKey: sortByKey)
        return SortBy(rawValue: 0)!
      }
    }
    set {
      UserDefaults.standard.setValue(newValue.rawValue, forKey: sortByKey)
    }
  }

  var currentInterfaceColor: UIColor {
    switch color {
      case .Blue:
        return UIColor.init(red: 100/255, green: 238/255, blue: 240/255, alpha: 0.58)
      case .Pink:
        return UIColor.init(red: 215/255, green: 131/255, blue: 255/255, alpha: 0.58)
      case .Green:
        return UIColor.init(red: 124/255, green: 173/255, blue: 121/255, alpha: 0.58)
    }
  }
  
  private init() {
    guard let color = UserDefaults.standard.value(forKey: colorSchemeKey) as? String,
          let colorScheme = ColorScheme(rawValue: color)
    else {
      self.color = .Blue
      UserDefaults.standard.setValue(ColorScheme.Blue.rawValue, forKey: colorSchemeKey)
      return
    }
    
    self.color = colorScheme
  }
}

extension SettingsManager {
  enum ColorScheme: String {
    case Blue
    case Pink
    case Green
  }
  
  enum SortBy: Int {
    case Name = 0
    case FileType = 1
  }
}
