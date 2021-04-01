//
//  TableViewController.swift
//  FileManager
//
//  Created by Helen Gokun on 29.03.2021.
//

import UIKit

class FileListTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.rowHeight = 80
    self.setupAppearance()
  }
  
  private func setupAppearance() {
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkText]
    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkText]
    navBarAppearance.backgroundColor = SettingsManager.shared.currentInterfaceColor
    self.navigationController?.navigationBar.standardAppearance = navBarAppearance
    self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    
    self.tableView.reloadData()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return FileListManager.shared.numberOfFiles()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as? FileListTableViewCell else { return UITableViewCell() }
    
    cell.fileTitleLabel.text = FileListManager.shared.nameOfFileAtIndex(indexPath.row)
    
    cell.fileImageView.tintColor = SettingsManager.shared.currentInterfaceColor
    switch FileListManager.shared.typeOfFileAtIndex(indexPath.row)
    {
      case .image:
        if SettingsManager.shared.hideThumbs {
          cell.fileImageView.image = UIImage(systemName: "photo")
        }
        else {
          let image = FileListManager.shared.contentOfImageFileAtIndex(indexPath.row)
          if let thumb = image {
            cell.fileImageView.image = thumb
          }
          else {
            cell.fileImageView.image = UIImage(systemName: "photo")
          }
        }
      case .music:
        cell.fileImageView.image = UIImage(systemName: "music.note.list")
      case .other:
        cell.fileImageView.image = UIImage(systemName: "doc.on.doc.fill")
    }
    
    return cell
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "ShowDetail" {
      guard  let detailsVC = segue.destination as? FileDetailsViewController else {
        return
      }
      
      let index = tableView.indexPathForSelectedRow?.row
      
      if let i = index {
        detailsVC.path = FileListManager.shared.pathOfFileAtIndex(i)
      }
    } else if segue.identifier == "ShowSettings"
    {
      guard  let settingsVC = segue.destination as? SettingsViewController else {
        return
      }
      settingsVC.doneBlock = {
        self.setupAppearance()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        FileListManager.shared.sort()
        self.tableView.reloadData()
      }
    }
  }
}
