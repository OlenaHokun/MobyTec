//
//  FileDetailsViewController.swift
//  FileManager
//
//  Created by Helen Gokun on 30.03.2021.
//

import Foundation
import UIKit

class FileDetailsViewController: UIViewController {
  private var file: File?
  var path: URL?
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var fileNameLabel: UILabel!
  @IBOutlet var createdDateLabel: UILabel!
  @IBOutlet var modifiedDateLabel: UILabel!
  @IBOutlet var sizeLabel: UILabel!
  @IBOutlet var detailsView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.detailsView.backgroundColor = SettingsManager.shared.currentInterfaceColor
    
    if let filePath = path
    {
      self.file = FileDetailsManager.fileForPath(filePath)
      
      if let file = self.file {
        self.fileNameLabel.text = file.name
        
        let createdDate = file.attributes[.creationDate] as? Date
        self.createdDateLabel.text = FileDetailsViewModel.formattedDate(createdDate)
        
        let modifyiedDate = file.attributes[.creationDate] as? Date
        self.modifiedDateLabel.text = FileDetailsViewModel.formattedDate(modifyiedDate)
        
        let size = file.attributes[.size] as? Int
        self.sizeLabel.text = FileDetailsViewModel.formattedFileSize(size: size)
        
        imageView.image = FileDetailsViewModel.imageForFile(file)
      }
    }
  }
  
  @IBAction func actionButtonPressed(_ sender: Any?) {
    guard let image = imageView.image else { return }
    let items = [image]
    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
    present(ac, animated: true)
  }
}
