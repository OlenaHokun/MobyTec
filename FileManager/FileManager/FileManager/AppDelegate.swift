//
//  AppDelegate.swift
//  FileManager
//
//  Created by Helen Gokun on 29.03.2021.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.copyFilesIfNeeded()
    
    return true
  }
  
  func copyFilesIfNeeded() {
    if !FileListManager.shared.filesCopyied()
    {
      FileListManager.shared.copyFromResources()
    }
  }
}

