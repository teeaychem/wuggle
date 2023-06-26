//
//  GameboardView.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit

class GameboardView: UIView {
  
  var tiles: [TileView] = []
  
  init(boardSize bS: CGFloat) {
    
    super.init(frame: CGRect(x: 0, y: 0, width: bS, height: bS))
    self.translatesAutoresizingMaskIntoConstraints = false
    layer.backgroundColor = UIColor.red.cgColor
    print("uiview", self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addTileSubview(tileView: TileView) {
    self.tiles.append(tileView)
    self.addSubview(tileView)
  }
  
  func displayTileViews() {
    for tile in tiles {
      tile.appear(animated: true)
    }
  }
  
  func hideTileViews() {
    for tile in tiles {
      tile.disappear(animated: true)
    }
  }
  
}

