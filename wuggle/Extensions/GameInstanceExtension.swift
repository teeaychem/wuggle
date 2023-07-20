//
//  SettingsExtension.swift
//  wuggle
//
//  Created by sparkes on 2023/06/24.
//

import Foundation
import CoreData

extension GameInstance {
  
  func populateBoard() {
    tileValues = Array(repeating: "", count: Int(settings!.tileSqrt * settings!.tileSqrt))
    
    let tileNum = self.settings!.tileSqrt

    let distribtion = [7.8,2,4,3.8,11,1.4,3,2.3,8.6,0.21,0.97,5.3,2.7,7.2,6.1,2.8,0.19,7.3,8.7,6.7,3.3,1,0.91,0.27,1.6,0.44]
    let alph = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "!", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    for i in (0 ..< tileNum) {
      for j in (0 ..< tileNum) {
        let tileIndex = i + j * settings!.tileSqrt
        tileValues![Int(tileIndex)] = alph[distributionSelect(dist: distribtion)]
      }
    }
  }
  
  func decrementTimeRemaning(dVal: Double) {
    // The speed at which the game updates is set by the view.
    // So, time remaning is passed as an argument.
    // Check to see if there's time remaning.
    // Then, ensure update to 0 at the lowest.
    // In the case of inf time, self.time > 0 is never satisfied.
    if self.settings!.time > 0 {
      self.timeUsedPercent = max(0, self.timeUsedPercent - dVal)
    }
  }
  
  
  func findPossibleWords(minLength mL: Int, sqrt: Int16) {
    guard self.settings?.currentGame != nil else { return }
    
    // TODO: Clean up
    // Ensure the dictionary is present
    
    print("made wordTileUseDict")
    

    // Call exploreTileWithList with helper variables.
    guard (self.tileValues != nil) else { return }
    
    // Get the trie root
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrieNode")
    fetchRequest.fetchLimit = 1
    do {
      guard (self.managedObjectContext != nil) else { return }
      
      let results = try self.managedObjectContext!.fetch(fetchRequest)
      
      if results.count > 0 {
        var node = results.first as! TrieNode
        node = node.getRoot()!
        // Not board. Instead, want set of numbers.
        var allTiles = Set<Int>()
        let allTileCount = Int(settings!.tileSqrt * settings!.tileSqrt)
        for i in 0 ..< allTileCount {
          allTiles.insert(i)
        }
        
        var usedTilesSet = [Int]()
        var wordString = ""
        for tile in allTiles {
          exploreTileWithList(tileIndex: tile,
                              totalTiles: allTileCount,
                              availableTiles: &allTiles,
                              usedTiles: &usedTilesSet,
                              trieNode: &node,
                              wordString: &wordString,
                              minLength: mL)
        }
        self.settings!.currentGame!.allWordsComplete = true
      }
    } catch {
      print("no found trie via settings")
    }
//    return nil
  }
  
  func exploreTileWithList(tileIndex: Int,
                           totalTiles: Int,
                           availableTiles: inout Set<Int>,
                           usedTiles: inout [Int],
                           trieNode: inout TrieNode,
                           wordString: inout String,
                           minLength mL: Int) {
    // Recusive function to explore a tile when finding words.
    // It's assumed the trieNode corresponds with the used tiles.
    // Starting from root, so always looking a trieNode ahead
    
    // Function is only called given a trie node, so it's safe to unwrap current.
    // However, there may be no child for the value of the tile.
    let tileValue = tileValues![tileIndex]
    
    if (trieNode.getChild(val: tileValue) != nil) {
      // We have a child, so this is worth exploring
      
      // Remove current tile from available
      availableTiles.remove(tileIndex)
      usedTiles.append(tileIndex)
      // Go to the appropriate child node
      trieNode = trieNode.getChild(val: tileValue)!
      // Add the value to the string
      wordString += tileValue
      
      // If this is a word, update the word list.
      let trueWordString = wordString.replacingOccurrences(of: "!", with: "Qu")
      if trieNode.isWord && trieNode.lexiconList![Int(settings!.lexicon)] && trueWordString.count >= mL {
        if !wordTileUseDict!.keys.contains(trueWordString) {
          wordTileUseDict!.updateValue(Array(repeating: false, count: totalTiles), forKey: trueWordString)
        }
        for tile in usedTiles {
          wordTileUseDict![trueWordString]![tile] = true
        }
      }
      // Restrict tiles to search.
      // Note: Current tile has been removed from available, so there's no need to exclude from surrounding tiles.
      let tilesToSearch = availableTiles.intersection(getSurroundingTilesInclusive(tile: tileIndex))
      
      for choiceTile in tilesToSearch {
        exploreTileWithList(tileIndex: choiceTile,
                            totalTiles: totalTiles,
                            availableTiles: &availableTiles,
                            usedTiles: &usedTiles,
                            trieNode: &trieNode,
                            wordString: &wordString,
                            minLength: mL)
      }
      
      // We're done exploring, so make the tile available again
      availableTiles.insert(tileIndex)
      usedTiles.removeLast()
      // Go to parent trie
      trieNode = trieNode.parent!
      // Remove tile value from wordString
      wordString.removeLast()
    }
  }
  
  func getSurroundingTilesInclusive(tile: Int) -> Set<Int> {
    // Get all the tiles surrounding a given tile, including the given tile.
    var outSet = Set<Int>()
    
    let tileSqrtInt = Int(settings!.tileSqrt)
    let (row, col) = splitTileRowCol(index: tile, tileSqrt: tileSqrtInt)

    for r in max(0, row - 1) ..< min(tileSqrtInt, row + 2) {
      for c in max(0, col - 1) ..< min(tileSqrtInt, col + 2) {
        // Indexing is from 0, so tileSqrt is one too big. <. This means r/c + 2
        outSet.insert(r + (c * tileSqrtInt))
      }
    }
    return outSet
  }  
}
