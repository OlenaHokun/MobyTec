//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Helen Gokun on 31.03.2021.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  @IBOutlet var showThumbsSwitch: UISwitch!
  @IBOutlet var sortingSegmented: UISegmentedControl!
  @IBOutlet var colorPicker: UIPickerView!
  @IBOutlet var navigationBar: UINavigationBar!
  
  var doneBlock: (() -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.showThumbsSwitch.isOn = !SettingsManager.shared.hideThumbs
    self.sortingSegmented.selectedSegmentIndex = SettingsManager.shared.sortBy.rawValue
    self.colorPicker.dataSource = self
    self.colorPicker.delegate = self
    
    self.setupInitialPickerValue()
    self.setupAppearance()
  }
  
  private func setupAppearance() {
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkText]
    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkText]
    navBarAppearance.backgroundColor = SettingsManager.shared.currentInterfaceColor
    self.navigationBar.standardAppearance = navBarAppearance
    self.navigationBar.scrollEdgeAppearance = navBarAppearance
  }
  
  private func setupInitialPickerValue() {
    self.colorPicker.reloadAllComponents()
    
    switch SettingsManager.shared.colorScheme {
      case .Blue:
        colorPicker.selectRow(0, inComponent: 0, animated: false)
      case .Pink:
        colorPicker.selectRow(1, inComponent: 0, animated: false)
      case .Green:
        colorPicker.selectRow(2, inComponent: 0, animated: false)
    }
  }
  
  // MARK: - UIPickerViewDataSource
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return SettingsManager.shared.numOfColorSchmes
  }
  
  // MARK: - UIPickerViewDelegate
  func pickerView(_ picker: UIPickerView, titleForRow: Int, forComponent: Int) -> String? {
    guard titleForRow < SettingsManager.shared.numOfColorSchmes else {
      return nil
    }
    
    switch titleForRow {
      case 0:
        return SettingsManager.ColorScheme.Blue.rawValue
      case 1:
        return SettingsManager.ColorScheme.Pink.rawValue
      case 2:
        return SettingsManager.ColorScheme.Green.rawValue
        
      default:
        return SettingsManager.ColorScheme.Blue.rawValue
    }
  }
  
  func pickerView(_ picker: UIPickerView, didSelectRow: Int, inComponent: Int)
  {
    guard didSelectRow < SettingsManager.shared.numOfColorSchmes else {
      return
    }
    
    switch didSelectRow {
      case 0:
        SettingsManager.shared.colorScheme = SettingsManager.ColorScheme.Blue
      case 1:
        SettingsManager.shared.colorScheme = SettingsManager.ColorScheme.Pink
      case 2:
        SettingsManager.shared.colorScheme = SettingsManager.ColorScheme.Green
        
      default:
        SettingsManager.shared.colorScheme = SettingsManager.ColorScheme.Blue
    }
  }
  
  // MARK: - Actions
  @IBAction func switcherSwitched(_ sender: Any?)
  {
    SettingsManager.shared.hideThumbs = !self.showThumbsSwitch.isOn
  }
  
  @IBAction func segmentChanged(_ sender: Any?)
  {
    SettingsManager.shared.sortBy = SettingsManager.SortBy(rawValue: self.sortingSegmented.selectedSegmentIndex) ?? SettingsManager.SortBy(rawValue: 0)!
  }
  
  @IBAction func rateButtonPressed(_ sender: Any?) {
    let alert = UIAlertController(title: NSLocalizedString("Thank you!", comment: ""), message: NSLocalizedString("Thank's for your five stars!", comment: ""), preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
      alert.dismiss(animated: true, completion: nil)
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func done(_ sender: Any?)
  {
    self.dismiss(animated: true, completion: self.doneBlock)
  }
}
