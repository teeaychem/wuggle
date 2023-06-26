//
//  GameboardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//
// A class to control gameboardviews.
// This has two uses.
// 1. The board played on.
// 2. Boards recorded with stats.

// TODO: Extend the init with boolean for interactive.
// If interactive, then hidden by default, and interaction extensions are available.
// if not, then simply display the board.

import UIKit

class GameboardViewController: UIViewController {

  let boardSize: CGFloat
  let tileWidth: CGFloat
  let tilePadding: CGFloat
  let gameboardView: GameboardView
  var tiles: [TileView] = []
  
  init(boardSize bS: CGFloat, gameBoard: Board) {
    
    boardSize = bS
    let tileSqrtFloat = CGFloat(gameBoard.tiles!.count).squareRoot()
    
    let unpaddedSize = boardSize / tileSqrtFloat
    
    tileWidth = unpaddedSize * 0.95
    tilePadding = (boardSize - (tileWidth * tileSqrtFloat)) / (tileSqrtFloat + 1)
    
    gameboardView = GameboardView(boardSize: bS)
    gameboardView.backgroundColor = UIColor.green
    gameboardView.layer.cornerRadius = getCornerRadius(width: boardSize)
    
    super.init(nibName: nil, bundle: nil)
    
    print("Adding game board")
    self.view.addSubview(gameboardView)
    createAllTileViews(board: gameBoard)
    displayTileViews()
    
  }
  
  func createAllTileViews(board: Board) {
    for tile in board.tiles! {
      let newTile = createTileView(tile: tile as! Tile)
      tiles.append(newTile)
      gameboardView.addSubview(newTile)
    }
  }
  
  func createTileView(tile: Tile) -> TileView {
    let xPosition = tilePadding + (tileWidth + tilePadding) * CGFloat(tile.row)
    let yPosition = tilePadding + (tileWidth + tilePadding) * CGFloat(tile.col)
    let tPosition = CGPoint(x: xPosition, y: yPosition)
    return TileView(position: tPosition, size: tileWidth, boardSize: boardSize, text: tile.value ?? "Qr")
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
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
