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

// Tiles are stored in coredata with Int16 x and y positions.
// To help pass this information around, this pair is combined to an Int16 by (x * 10) + y.
// This is easy to encode and decode.

import UIKit

class GameboardViewController: UIViewController {

  let boardSize: CGFloat
  let tileWidth: CGFloat
  let tilePadding: CGFloat
  let tileSqrtFloat: CGFloat
  let gameboardView: GameboardView
  
  init(boardSize bS: CGFloat, gameBoard: Board) {
    
    // Constants for placing elements
    boardSize = bS
    
    tileSqrtFloat = CGFloat(gameBoard.tiles!.count).squareRoot()
    let unpaddedSize = boardSize / tileSqrtFloat
    
    tileWidth = unpaddedSize * 0.95
    tilePadding = (boardSize - (tileWidth * tileSqrtFloat)) / (tileSqrtFloat + 1)
    
    // Setup the view
    gameboardView = GameboardView(boardSize: bS)
    gameboardView.backgroundColor = UIColor.darkGray
    gameboardView.layer.cornerRadius = getCornerRadius(width: boardSize)
    
    super.init(nibName: nil, bundle: nil)
    
    // Create the tiles
    createAllTileViews(board: gameBoard)
  }
  
  override func loadView() {
    super.loadView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Add the view as a subview
    self.view.addSubview(gameboardView)
  }
  
  override func viewDidLayoutSubviews() {
    // Before this is called the frame of the view has not been set.
    // So, this seems to be the appropriate place to fix things.
    // https://stackoverflow.com/questions/40737164/whats-exactly-viewdidlayoutsubviews
    super.viewDidLayoutSubviews()
    view.frame.size = CGSize(width: boardSize, height: boardSize)
  }
  
  func tileLocationCombine(x: Int16, y: Int16) -> Int16 {
    return x * 10 + y
  }
  
  func tileLocationSplit(combined: Int16) -> (Int16, Int16) {
    return combined.quotientAndRemainder(dividingBy: 10)
  }
  
  
  func createAllTileViews(board: Board) {
    for tile in board.tiles! {
      let tileTrueForm = tile as! Tile
      let newTile = createTileView(tile: tileTrueForm)
      let tileKey = tileLocationCombine(x: tileTrueForm.col, y: tileTrueForm.row)
      gameboardView.addTileSubview(tileKey: tileKey, tileView: newTile)
    }
  }
  
  func createTileView(tile: Tile) -> TileView {
    let xPosition = tilePadding + (tileWidth + tilePadding) * CGFloat(tile.col - 1)
    let yPosition = tilePadding + (tileWidth + tilePadding) * CGFloat(tile.row - 1)
    let tPosition = CGPoint(x: xPosition, y: yPosition)
    return TileView(position: tPosition, size: tileWidth, boardSize: boardSize, text: tile.value ?? "Qr")
  }
  
  func selectTile(tileIndex: Int16) {
    gameboardView.tiles[tileIndex]?.tileSelected()
  }

  func deselectTile(tileIndex: Int16) {
    gameboardView.tiles[tileIndex]?.tileDeselected()
  }
  
  func getTileValue(tileIndex: Int16) -> String {
    return gameboardView.tiles[tileIndex]?.text ?? ""
    
  }

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func basicTilePositionFromCGPoint(point: CGPoint) -> Int16? {
    // Transforms a position point to a tile point.
    // Optional, as two checks:
    // 1. Going going outside the board.
    // 2. Indeterminate points between two tiles.
    
    // I feel this can be improved, but there's no significant CPU usage.
    
    let xPercent = point.x/boardSize
    let yPercent = point.y/boardSize
    
    guard (0 < xPercent && xPercent < 1 && 0 < yPercent && yPercent < 1) else {
      // Guard against going outside the board
      return nil
    }
    
    let xVal = xPercent * tileSqrtFloat
    let yVal = yPercent * tileSqrtFloat
    let xRemainder = xVal.truncatingRemainder(dividingBy: 1)
    let yRemainder = yVal.truncatingRemainder(dividingBy: 1)
    
    guard (0.1 < xRemainder && xRemainder < 0.9 && 0.1 < yRemainder && yRemainder < 0.9) else {
      // Guard against indeterminate points
      return nil
    }
    
    return Int16(xVal + 1) * 10 + Int16(yVal + 1)
    
//    return CGPoint(x: xVal.rounded(FloatingPointRoundingRule.down), y: yVal.rounded(FloatingPointRoundingRule.down))
  }
  

}
