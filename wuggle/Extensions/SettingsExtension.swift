//
//  SettingsExtension.swift
//  wuggle
//
//  Created by sparkes on 2023/06/26.
//

import Foundation
import CoreData
import UIKit

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
      self.managedObjectContext?.delete(self.currentGame!)
    }
    self.currentGame = GameInstance(context: self.managedObjectContext!)
    self.currentGame!.populateBoard()
    self.currentGame!.foundWordsList = []
    self.currentGame!.wordTileUseDict = Dictionary<String, [Bool]>()
    self.currentGame!.tileUseCache = [] // Only filled when cache has been set.
  }
  
  
  func getTrieRoot() -> TrieNode? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrieNode")
    fetchRequest.fetchLimit = 1
    do {
      let result = try self.managedObjectContext!.fetch(fetchRequest)
      
      if result.count > 0 {
        let node = result.last as! TrieNode
        return node.getRoot()!
      }
    } catch { }
    return nil
  }
  
  
  func timeOptionBlob() -> OptionBlob {
    return OptionBlob(internalName: "time", displayName: "Minutes", internalOptions: [60, 120, 180, 300, 420, -1], displayOptions: ["1", "2", "3", "5", "7", "∞"])
  }
  
  
  func lexiconOptionBlob() -> OptionBlob {
    return OptionBlob(internalName: "lexicon", displayName: "Lexicon", internalOptions: [0, 1, 2, 3, 4], displayOptions: ["Classic (12dicts 3of6)", "Odgen's Basic", "Jane Austen", "King James Bible", "Shakespeare"])
  }
  
  
  func lengthOptionBlob() -> OptionBlob {
    return OptionBlob(internalName: "length", displayName: "Word length", internalOptions: [3, 4, 5, 6], displayOptions: ["3+", "4+", "5+", "6+"])
  }
  
  
  func tilesOptionBlob() -> OptionBlob {
    return OptionBlob(internalName: "tiles", displayName: "Tiles", internalOptions: [2, 3, 4, 5, 6, 7, 8], displayOptions: ["2²", "3²", "4²", "5²", "6²", "7²", "8²"])
  }
  
  
  func pFoundOptionBlob() -> OptionBlob {
    return OptionBlob(internalName: "pfound", displayName: "Show % of words found", internalOptions: [1, 0], displayOptions: ["Yes", "No"])
  }
  
  
  func impactOptionBlob() -> OptionBlob {
    return OptionBlob(internalName: "impact", displayName: "Impact", internalOptions: [1, 0], displayOptions: ["On", "Off"])
  }
  
  
  func sideOptionBlob() -> OptionBlob {
    return OptionBlob(internalName: "side", displayName: "Clock side", internalOptions: [1, 0], displayOptions: ["L", "R"])
  }
  
  
  func colourOptionBlob() -> OptionBlob {
    return OptionBlob(internalName: "colour", displayName: "Colour", internalOptions: [0, 1, 2, 3, 4, 5], displayOptions: ["๑", "๒", "๓", "๔", "๕", "๖"])
  }
  
  func fadeOptionBlob() -> OptionBlob {
    return OptionBlob(internalName: "fade", displayName: "Fade exhausted tiles", internalOptions: [1, 0], displayOptions: ["Yes", "No"])
  }
  
  
  func doSave() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    if context.hasChanges {
      do {
        try self.managedObjectContext!.save()
      } catch { }
    } else { }
  }
}
