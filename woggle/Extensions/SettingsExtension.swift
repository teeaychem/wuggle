//
//  SettingsExtension.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import Foundation
import CoreData

extension Settings {
  
  func populateBoard() {
    print("Make board")
    self.board = Board(context: self.managedObjectContext!)
    
    let tileNum = self.tileSqrt

    let distribtion = [7.8,2,4,3.8,11,1.4,3,2.3,8.6,0.21,0.97,5.3,2.7,7.2,6.1,2.8,0.19,7.3,8.7,6.7,3.3,1,0.91,0.27,1.6,0.44]
    let alph = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "!", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
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
    
    if self.time > 0 {
      self.timeRemaining = max(0, self.timeRemaining - dVal)
    }
  }
  
  func findAllWords() {
    //
    guard (self.board != nil) else { print("no board"); return }
    print("board ok")
    
    // Get the trie root
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrieNode")
    do {
      guard (self.managedObjectContext != nil) else { return }
      
      let results = try self.managedObjectContext!.fetch(fetchRequest)
      
      if results.count > 0 {
        print("found trie via settings")
        var node = results.first as! TrieNode
        node = node.goToRoot()!
        var allTiles = self.board!.tiles! as! Set<Tile>
//        for tile in allTiles {
//          print(tile.value)
//        }
        
        var wordSet = Set<String>()
        var wordString = ""
        for tile in allTiles {
          exploreTileWithList(tile: tile, availableTiles: &allTiles, trieNode: &node, wordString: &wordString, wordSet: &wordSet)
        }
        print(wordSet)
      }
    } catch {
      print("no found trie via settings")
    }
  }
  
  func exploreTileWithList(tile: Tile, availableTiles: inout Set<Tile>, trieNode: inout TrieNode, wordString: inout String, wordSet: inout Set<String>) {
    // A function to explore a tile when finding words.
    // It's assumed the trieNode corresponds with the used tiles.
    // Starting from root, so always looking a trieNode ahead
    
    // Function is only called given a trie node, so it's safe to unwrap current.
    // However, there may be no child for the value of the tile.
    if (trieNode.getChild(val: tile.value!) != nil) {
      // We have a child, so this is worth exploring

      
      // Remove current tile from available
      availableTiles.remove(tile)
      // Go to the appropriate child node
      trieNode = trieNode.getChild(val: tile.value!)!
      // Add the value to the string
      wordString += tile.value!
      
      // If this is a word, update the word list.
      if trieNode.isWord {
        wordSet.insert(wordString)
      }
      
      // Restrict tiles to search.
      let tilesToSearch = availableTiles.intersection(getSurroundingTilesInclusive(tile: tile))
      
      for choiceTile in tilesToSearch {
        exploreTileWithList(tile: choiceTile, availableTiles: &availableTiles, trieNode: &trieNode, wordString: &wordString, wordSet: &wordSet)
      }
      
      // We're done exploring, so make the tile available again
      availableTiles.insert(tile)
      // Go to parent trie
      trieNode = trieNode.parent!
      // Remove tile value from wordString
      wordString.removeLast()
    }
  }
  
  func getSurroundingTilesInclusive(tile: Tile) -> Set<Tile> {
    // Get all the tiles surrounding a given tile, including the given tile
    
    let areaPredicate = NSPredicate(format: "(row BETWEEN %@) && (col BETWEEN %@)", [(tile.row - 1), (tile.row + 1)], [(tile.col - 1), (tile.col + 1)])
    var sTiles = Set<Tile>()
    for t in self.board!.tiles!.filtered(using: areaPredicate) {
      sTiles.insert(t as! Tile)
    }
    
    return sTiles
  }
  
  func getTilesToExplore(tile: inout Tile, usedTiles: inout [Tile]) -> [Tile] {
    // Returns all the tiles which surround the input tile which are not in the usedTiles.
    var tilesToExplore = [Tile]()
    var rowOptions = [Int16]()
    if tile.row < self.tileSqrt {
      rowOptions.append(tile.row - 1)
    }
    if tile.row > 0 {
      rowOptions.append(tile.row + 1)
    }
    var colOptions = [Int16]()
    if tile.col < self.tileSqrt {
      colOptions.append(tile.col - 1)
    }
    if tile.col > 0 {
      colOptions.append(tile.col + 1)
    }
    
    let adjoiningPredicate = NSPredicate(format: "(row == %i || row == %i) && (col == %i || col == %i)", tile.row - 1, tile.row + 1, tile.col - 1, tile.col + 1)
    for result in self.board!.tiles!.filtered(using: adjoiningPredicate) {
      tilesToExplore.append(result as! Tile)
    }
    print("tile", tile)
    print("tiles to explore", tilesToExplore)
    return tilesToExplore
  }
  
  func processStats() {
    // TODO: Add methods which check to see if there's a stats file.
    // If yes, check against current stats and update if needed.
    // If no, create relevant stats.
    // So, individual methods for each stat
  }
  

  
  
  
  
}
