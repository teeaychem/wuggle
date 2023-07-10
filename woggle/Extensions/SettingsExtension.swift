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
  
  
  func setNewGame() {
    if (self.currentGame != nil) {
      self.managedObjectContext?.delete(self.currentGame!)
    }
    self.currentGame = GameInstance(context: self.managedObjectContext!)
    self.currentGame!.populateBoard()
    self.currentGame!.foundWordsList = []
    self.currentGame!.allWordsList = []
  }
  
  
  func getTrieRoot() -> TrieNode {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrieNode")
    fetchRequest.fetchLimit = 1
    do {
      let result = try self.managedObjectContext!.fetch(fetchRequest)
      
      if result.count > 0 {
        let node = result.last as! TrieNode
        return node.getRoot()!
      }
    } catch {
      print("error")
    }
    return TrieNode(context: self.managedObjectContext!)
  }
  
  
  
  
  
}
