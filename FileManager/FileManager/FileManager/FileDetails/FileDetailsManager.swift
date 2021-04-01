//
//  FileDetailsManager.swift
//  FileManager
//
//  Created by Helen Gokun on 30.03.2021.
//

import Foundation

class FileDetailsManager {
  static func fileForPath(_ path: URL) -> File
  {
    return File(name: path.lastPathComponent,
                path: path,
                attributes: FileListManager.shared.attributesForFileAtPath(path),
                type: FileListManager.shared.typeOfFileAtPath(path))
  }
}
