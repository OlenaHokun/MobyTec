//
//  FileDetailsViewModel.swift
//  FileManager
//
//  Created by Helen Gokun on 30.03.2021.
//

import Foundation
import UIKit

class FileDetailsViewModel {
  
  static func formattedDate(_ dateToFormat: Date?) -> String
  {
    guard let date = dateToFormat else {
      return "-"
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    let formattedString = dateFormatter.string(from: date)
    
    return formattedString
  }
  
  static func formattedFileSize(size: Int?) -> String
  {
    guard let fileSize = size else {
      return "0 B"
    }
    return "\(fileSize) B"
  }
  
  static func imageForFile(_ file: File) -> UIImage {
    let image: UIImage
    
    switch file.type {
      case .image:
        let stringPath = file.path.absoluteString.dropFirst(7)
        image = UIImage(contentsOfFile: String(stringPath)) ?? UIImage(imageLiteralResourceName: "AnyFile")
      case .music:
        image = UIImage(imageLiteralResourceName: "MusicFile")
      case .other:
        image = UIImage(imageLiteralResourceName: "AnyFile")
    }
    
    return image
  }
}
