//
//  File.swift
//  FileManager
//
//  Created by Helen Gokun on 30.03.2021.
//

import Foundation

struct File {
  let name: String
  let path: URL
  let attributes: [FileAttributeKey : Any]
  let type: FileListManager.FileTypes
}
