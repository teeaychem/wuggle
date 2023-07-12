//
//  SettingsExtension.swift
//  woggle
//
//  Created by sparkes on 2023/06/26.
//

import Foundation
import CoreData

extension Settings {
  
  
  func ensureDefaults() {
    if stats == nil {
      stats = StatsCollection(context: managedObjectContext!)
    }
    if stats!.topPercent == nil {
      stats!.topPercent = Stat(context: managedObjectContext!)
    }
    if stats!.topPoints == nil {
      stats!.topPoints = Stat(context: managedObjectContext!)
    }
    if stats!.topRatio == nil {
      stats!.topRatio = Stat(context: managedObjectContext!)
    }
    if stats!.topWordLength == nil {
      stats!.topWordLength = Stat(context: managedObjectContext!)
    }
    if stats!.topWords == nil {
      stats!.topWords = Stat(context: managedObjectContext!)
    }
    if stats!.topWordPoints == nil {
      stats!.topWordPoints = Stat(context: managedObjectContext!)
    }
  }
  
  
  func returnContext() -> NSManagedObjectContext {
    return self.managedObjectContext!
  }
  
  func getCurrentGame() -> GameInstance? {
    return self.currentGame
  }
  
  
  func setNewGame() {
    if (self.currentGame != nil) {
      print("Deleted game")
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
