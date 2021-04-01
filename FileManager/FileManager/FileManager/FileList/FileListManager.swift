//
//  FileListViewModel.swift
//  FileManager
//
//  Created by Helen Gokun on 29.03.2021.
//

import Foundation
import UIKit

class FileListManager {
  static let shared = FileListManager()
  private let filesCopyiedKey = "FILES_COPYIED"
  var files: [URL]?
  
  private init() {
    if UserDefaults.standard.bool(forKey: filesCopyiedKey) {
      files = try? FileManager.default.contentsOfDirectory(at: filesPath(), includingPropertiesForKeys: nil)
    }
    
    self.sort()
  }
  
  func filesPath() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    let path = documentsDirectory.appendingPathComponent("Files")
    
    NSLog("Files path: \(path)")
    return path
  }
  
  // MARK: - Copying files from resources
  func filesCopyied() -> Bool {
    let copyied = UserDefaults.standard.bool(forKey: filesCopyiedKey)
    return copyied
  }
  
  func copyFromResources() {
    let path = Bundle.main.resourceURL
    
    guard let resourcePath = path
    else {
      NSLog("Cannot find resource path")
      return
    }
    
    let dirContents = try? FileManager.default.contentsOfDirectory(at: resourcePath, includingPropertiesForKeys: nil)
    guard let contents = dirContents else {
      NSLog("No resource files")
      return
    }
    
    let files: [URL] = contents.filter{ (file) -> Bool in
      file.lastPathComponent.contains("file")
    }
    
    do {
      try FileManager.default.createDirectory(at: filesPath(), withIntermediateDirectories: true, attributes: nil)
    } catch {
      NSLog("Error creating folder")
      return
    }
    
    for file in files
    {
      let newFilePath = filesPath().appendingPathComponent(file.lastPathComponent.replacingOccurrences(of: "_file", with: ""))
      do {
        try FileManager.default.copyItem(at: file, to: newFilePath)
      } catch {
        NSLog("Error copying file: \(file) to \(newFilePath)")
      }
    }
    
    self.files = try? FileManager.default.contentsOfDirectory(at: filesPath(), includingPropertiesForKeys: nil)
    
    self.sort()
    
    UserDefaults.standard.set(true, forKey: filesCopyiedKey)
  }
  
  // MARK: - Accessing files and attributes
  func numberOfFiles() -> Int {
    if !filesCopyied()
    {
      return 0
    }
    
    let count = self.files?.count
    
    return count ?? 0
  }
  
  func pathOfFileAtIndex(_ index: Int) -> URL?
  {
    guard let count = self.files?.count, count > index else { return nil }
    
    let path = filesPath().appendingPathComponent(nameOfFileAtIndex(index))
    return path
  }
  
  func typeOfFileAtPath(_ path: URL) -> FileTypes {
    let ex = path.pathExtension
    
    if let type = FileTypes(rawValue: String(ex))
    {
      return type
    }
    
    return .other
  }
  
  func attributesForFileAtPath(_ path: URL) -> [FileAttributeKey : Any] {
    let stringPath = path.absoluteString.dropFirst(7)
    let attributes: [FileAttributeKey : Any]
    
    do {
      try attributes = FileManager.default.attributesOfItem(atPath: String(stringPath))
    } catch {
      NSLog("Error obtaining file attributes: \(stringPath)")
      return [:]
    }
    return attributes
  }
  
  func nameOfFileAtIndex(_ index: Int) -> String {
    guard let count = self.files?.count, count > index else { return "" }
    
    return self.files![index].lastPathComponent
  }
  
  func typeOfFileAtIndex(_ index: Int) -> FileTypes {
    let file = self.files![index]
    let ex = file.pathExtension
    
    if let type = FileTypes(rawValue: String(ex))
    {
      return type
    }
    
    return .other
  }
  
  func contentOfImageFileAtIndex(_ index: Int) -> UIImage? {
    if typeOfFileAtIndex(index) != .image {
      return nil
    }
    let path = filesPath().appendingPathComponent(nameOfFileAtIndex(index))
    let stringPath = path.absoluteString.dropFirst(7)
    let image = UIImage(contentsOfFile: String(stringPath))
    return image
  }
  
  // MARK: - Sorting
  func sort() {
    if let _ = self.files {
      if SettingsManager.shared.sortBy == .Name {
        self.sortFilesByName()
      }
      else {
        self.sortFilesByType()
      }
    }
  }
  
  func sortFilesByName() {
    if self.files == nil {
      return
    }
    
    let newFiles = self.files?.sorted(by: { (url1, url2) -> Bool in
      let name1 = url1.lastPathComponent
      let name2 = url2.lastPathComponent
      
      return name1 < name2
    })
    
    self.files = newFiles
  }
  
  func sortFilesByType() {
    if self.files == nil {
      return
    }
    
    let newFiles = self.files?.sorted(by: { (url1, url2) -> Bool in
      let ex1 = url1.pathExtension
      let ex2 = url2.pathExtension
      
      return ex1 < ex2
    })
    
    self.files = newFiles
  }
}

extension FileListManager {
  enum FileTypes: String {
    case image = "jpg"
    case music = "mp3"
    case other
  }
}
