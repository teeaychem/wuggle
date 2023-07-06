//
//  CardStackProtocol.swift
//  woggle
//
//  Created by sparkes on 2023/06/27.
//

import Foundation

protocol CardStackDelegate: AnyObject {
  // CardViewControllers have a cardStackDelegate.
  // This allows each individual card to make a request to the cardStack controller.
  // And, then the cardStackController processes the request.
  
  // Used to request some UI update, such as updating the longest word or most points.
  func processUpdate()
  
  // Used to update particular setting
  func updateSetting(internalName: String, internalValue: Int16)
  
  // Allow cards to request current settings.
  // Cards should not store settings in order to ensure a unique settings file is in use at any given time.
  func currentSettings() -> Settings
  
  // Allow cards to request current gameInstance.
  func currentGameInstance() -> GameInstance?
}
