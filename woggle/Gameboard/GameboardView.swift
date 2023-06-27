//
//  GameboardView.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit

class GameboardView: UIView {
  
  // TODO: Update this to a dictionary, so tiles are easily found by giving CGPoint.
  var tiles = Dictionary<Int16, TileView>()
  
  init(boardSize bS: CGFloat) {
    
    super.init(frame: CGRect(x: 0, y: 0, width: bS, height: bS))
    self.translatesAutoresizingMaskIntoConstraints = false
    layer.backgroundColor = UIColor.red.cgColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addTileSubview(tileKey: Int16, tileView: TileView) {
    tiles.updateValue(tileView, forKey: tileKey)
//    self.tiles.append(tileView)
    self.addSubview(tileView)
  }
  
  func displayTileViews() {
    for tile in tiles.values {
      tile.appear(animated: true)
    }
  }
  
  func hideTileViews() {
    for tile in tiles.values {
      tile.disappear(animated: true)
    }
  }
  
}

