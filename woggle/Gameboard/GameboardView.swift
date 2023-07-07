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
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setOpacity(to: Float) {
    for v in subviews {
      v.layer.opacity = to
    }
  }
  
  
  func addTileSubview(tileKey: Int16, tileView: TileView) {
    tiles.updateValue(tileView, forKey: tileKey)
    self.addSubview(tileView)
  }
  
  
  func removeAllTileViews() {
    for tile in tiles.values {
      tile.disappear(animated: false)
      tile.removeFromSuperview()
    }
    tiles.removeAll()
  }
  
  
  func displayTileViews() {
    for tile in tiles.values {
      tile.displayLetter(animated: true)
    }
  }
  
  
  func hideTileViews(animated a: Bool) {
    for tile in tiles.values {
      tile.disappear(animated: a)
    }
  }
  
}

