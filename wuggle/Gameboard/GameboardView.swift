//
//  GameboardView.swift
//  wuggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit

class GameboardView: UIView {
  
  var tiles = Dictionary<Int, TileView>()
  
  init(boardSize bS: CGFloat) {
    
    super.init(frame: CGRect(x: 0, y: 0, width: bS, height: bS))
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func addTileSubview(tileKey: Int, tileView: TileView) {
    tiles.updateValue(tileView, forKey: tileKey)
    self.addSubview(tileView)
  }
  
}

