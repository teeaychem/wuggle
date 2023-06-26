//
//  SettingsExtension.swift
//  woggle
//
//  Created by sparkes on 2023/06/26.
//

import Foundation

extension Settings {
  
  func getOrMakeCurrentGame() -> GameInstance {
    if (self.currentGame == nil) {
      self.currentGame = GameInstance(context: self.managedObjectContext!)
      self.currentGame!.populateBoard()
    }
    return self.currentGame!
  }
  
  
  
  
  
}
