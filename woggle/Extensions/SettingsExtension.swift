//
//  SettingsExtension.swift
//  woggle
//
//  Created by sparkes on 2023/06/26.
//

import Foundation
import CoreData

extension Settings {
  
  func returnContext() -> NSManagedObjectContext {
    return self.managedObjectContext!
  }
  
  
  
  func getCurrentGame() -> GameInstance? {
    return self.currentGame
  }
  
  
  func setAndGetNewGame() -> GameInstance {
    self.currentGame = GameInstance(context: self.managedObjectContext!)
    self.currentGame!.populateBoard()
    return self.currentGame!
  }
  
  
  
  func getOrMakeCurrentGame() -> GameInstance {
    if (self.currentGame == nil) {
      self.currentGame = GameInstance(context: self.managedObjectContext!)
      self.currentGame!.populateBoard()
    }
    return self.currentGame!
  }
  
  func getTrieRoot() -> TrieNode {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrieNode")
    do {
      let result = try self.managedObjectContext!.fetch(fetchRequest)
      
      if result.count > 0 {
        let node = result.last as! TrieNode
        return node.goToRoot()!
      }
    } catch {
      print("error")
    }
    return TrieNode(context: self.managedObjectContext!)
  }
  
  
  
  
  
}
