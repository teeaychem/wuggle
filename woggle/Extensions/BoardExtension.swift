//
//  BoardExtension.swift
//  moreWaggle
//
//  Created by sparkes on 2023/06/23.
//

import CoreData

extension Board {
  
  func makeBoard(context: NSManagedObjectContext) {
    print("Make board")
    
    let tileNum = self.settings!.tileSqrt
  
    // For testing
    let distribtion = [1.0]
//    let distribtion = [7.8,2,4,3.8,11,1.4,3,2.3,8.6,0.21,0.97,5.3,2.7,7.2,6.1,2.8,0.19,7.3,8.7,6.7,3.3,1,0.91,0.27,1.6,0.44]
    let alph = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "!", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    print(distribtion.count)

    
    for i in (0 ..< tileNum) {
      for j in (0 ..< tileNum) {
        let tile = Tile(context: context)
        tile.col = i
        tile.row = j
        tile.value = alph[distributionSelect(dist: distribtion)]
        self.addToTiles(tile)
      }
    }
  }
  
  func getCompleteWordSet() -> Set<String> {
    // TODO
    
    // Work through each time to exhaust options.
    
    return Set()
  }
  
  func foundWordsCount() -> Int {
    return self.foundWords!.count
  }
  
}
