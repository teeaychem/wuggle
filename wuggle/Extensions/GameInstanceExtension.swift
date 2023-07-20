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
    self.board = Board(context: self.managedObjectContext!)
    
    let tileNum = self.settings!.tileSqrt

    let distribtion = [7.8,2,4,3.8,11,1.4,3,2.3,8.6,0.21,0.97,5.3,2.7,7.2,6.1,2.8,0.19,7.3,8.7,6.7,3.3,1,0.91,0.27,1.6,0.44]
    let alph = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "!", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    for i in (0 ..< tileNum) {
      for j in (0 ..< tileNum) {
        let tile = Tile(context: self.managedObjectContext!)
        tile.col = i
        tile.row = j
        tile.value = alph[distributionSelect(dist: distribtion)]
        board!.addToTiles(tile)
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
    tileUse = Dictionary<String, [Bool]>()
//    for tile in board!.tiles! {
//      let trueForm = tile as! Tile
//      let rep = trueForm.col + (trueForm.row * sqrt)
//      tileUse!.updateValue(Array(repeating: false, count: Int(sqrt * sqrt)), forKey: )
//    }
    
    
    self.settings!.currentGame!.allWordsList = findAllWords(minLength: mL)?.sorted()
    self.settings!.currentGame!.allWordsComplete = true
  }
  
  func findAllWords(minLength mL: Int) -> Set<String>? {
    // Call exploreTileWithList with helper variables.
    guard (self.board != nil) else { return nil }
    
    // Get the trie root
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrieNode")
    fetchRequest.fetchLimit = 1
    do {
      guard (self.managedObjectContext != nil) else { return nil }
      
      let results = try self.managedObjectContext!.fetch(fetchRequest)
      
      if results.count > 0 {
        var node = results.first as! TrieNode
        node = node.getRoot()!
        var allTiles = self.board!.tiles! as! Set<Tile>
        var usedTilesSet = [Tile]()
        var wordSet = Set<String>()
        var wordString = ""
        for tile in allTiles {
          exploreTileWithList(tile: tile, availableTiles: &allTiles, usedTiles: &usedTilesSet, trieNode: &node, wordString: &wordString, wordSet: &wordSet, minLength: mL)
        }
        return wordSet
      }
    } catch {
      print("no found trie via settings")
    }
    return nil
  }
  
  func exploreTileWithList(tile: Tile, availableTiles: inout Set<Tile>, usedTiles: inout [Tile], trieNode: inout TrieNode, wordString: inout String, wordSet: inout Set<String>, minLength mL: Int) {
    // Recusive function to explore a tile when finding words.
    // It's assumed the trieNode corresponds with the used tiles.
    // Starting from root, so always looking a trieNode ahead
    
    // Function is only called given a trie node, so it's safe to unwrap current.
    // However, there may be no child for the value of the tile.
    if (trieNode.getChild(val: tile.value!) != nil) {
      // We have a child, so this is worth exploring
      
      // Remove current tile from available
      availableTiles.remove(tile)
      usedTiles.append(tile)
      // Go to the appropriate child node
      trieNode = trieNode.getChild(val: tile.value!)!
      // Add the value to the string
      wordString += tile.value!
      
      // If this is a word, update the word list.
      let trueWordString = wordString.replacingOccurrences(of: "!", with: "Qu")
      if trieNode.isWord && trieNode.lexiconList![Int(settings!.lexicon)] && trueWordString.count >= mL {
        if !wordSet.contains(trueWordString) {
          tileUse?.updateValue(Array(repeating: false, count: availableTiles.count + usedTiles.count), forKey: trueWordString)
          wordSet.insert(trueWordString)
        }
        for tile in usedTiles {
          let rep = tile.col + (tile.row * self.settings!.tileSqrt)
          tileUse![trueWordString]![Int(rep)] = true
        }
      }
      
      // Restrict tiles to search.
      // Note: Current tile has been removed from available, so there's no need to exclude from surrounding tiles.
      let tilesToSearch = availableTiles.intersection(getSurroundingTilesInclusive(tile: tile))
      
      for choiceTile in tilesToSearch {
        exploreTileWithList(tile: choiceTile, availableTiles: &availableTiles, usedTiles: &usedTiles, trieNode: &trieNode, wordString: &wordString, wordSet: &wordSet, minLength: mL)
      }
      
      // We're done exploring, so make the tile available again
      availableTiles.insert(tile)
      usedTiles.removeLast()
      // Go to parent trie
      trieNode = trieNode.parent!
      // Remove tile value from wordString
      wordString.removeLast()
    }
  }
  
  func getSurroundingTilesInclusive(tile: Tile) -> Set<Tile> {
    // Get all the tiles surrounding a given tile, including the given tile.
    // To keep the predicate simple, this include the tile given as an argument.
  
    let areaPredicate = NSPredicate(format: "(row BETWEEN %@) && (col BETWEEN %@)", [(tile.row - 1), (tile.row + 1)], [(tile.col - 1), (tile.col + 1)])
    
    return self.board!.tiles!.filtered(using: areaPredicate) as! Set<Tile>
  }  
}
