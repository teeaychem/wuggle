//
//  SettingsCardViewControllerDelegate.swift
//  woggle
//
//  Created by sparkes on 2023/07/05.
//

import Foundation

protocol SettingsCardViewControllerDelegate: AnyObject {
  
  func updateSetting(internalName: String, internalValue: Int16)
  
  func getUIData() -> UIData
  
}
