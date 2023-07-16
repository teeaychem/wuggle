//
//  GameboardViewController.swift
//  wuggle
//
//  Created by sparkes on 2023/06/24.
//
// A class to control gameboardviews.
// This has two uses.
// 1. The board played on.
// 2. Boards recorded with stats.

// Tiles are stored in coredata with Int16 x and y positions.
// To help pass this information around, this pair is combined to an Int16 by (x * 10) + y.
// This is easy to encode and decode.

import UIKit


class GameboardViewController: UIViewController {
  
  let gameboardView: GameboardView
  let uiData: UIData
  
  init(uiData uiD: UIData, tilePadding tP: CGFloat) {
    
    // Constants for placing elements
    uiData = uiD

    // Setup the view
    gameboardView = GameboardView(boardSize: uiD.gameBoardSize)
    gameboardView.backgroundColor = uiD.colourD
    gameboardView.layer.cornerRadius = getCornerRadius(width: uiD.gameBoardSize)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.frame.size = CGSize(width: uiData.gameBoardSize, height: uiData.gameBoardSize)
    view.addSubview(gameboardView)
  }
  
 
  override func viewDidLayoutSubviews() {
    // Before this is called the frame of the view has not been set.
    // So, this seems to be the appropriate place to fix things.


    // https://stackoverflow.com/questions/40737164/whats-exactly-viewdidlayoutsubviews
    super.viewDidLayoutSubviews()
    
  }
  
  
  func tileLocationCombine(x: Int16, y: Int16) -> Int16 {
    return x * 10 + y
  }
  
  
  func tileLocationSplit(combined: Int16) -> (Int16, Int16) {
    return combined.quotientAndRemainder(dividingBy: 10)
  }
  
  
  func createAllTileViews(board: Board) {
    
    removeAllTileViews()
    
    let tileSqrtFloat = sqrt(Double(board.tiles!.count))
    let tilePadding = uiData.gameBoardSize * 0.01
    let tileWidth = (uiData.gameBoardSize - (tilePadding * (tileSqrtFloat + 1))) / tileSqrtFloat
    
    for tile in board.tiles! {
      let tileTrueForm = tile as! Tile
      let newTile = createTileView(tile: tileTrueForm, tileWidth: tileWidth, tilePadding: tilePadding)
      let tileKey = tileLocationCombine(x: tileTrueForm.col, y: tileTrueForm.row)
      gameboardView.addTileSubview(tileKey: tileKey, tileView: newTile)
    }
  }
  
  
  func displayTileFoundationAll() {
    for tile in gameboardView.tiles.values {
      tile.displayTile()
    }
  }
  
  
  func displayTileCharacterAll(animated a: Bool) {
    for tile in gameboardView.tiles.values {
      tile.displayLetter(animated: a)
    }
  }
  
  
  func removeAllTileViews() {
    for tile in gameboardView.tiles.values {
        tile.disappear(animated: false)
        tile.removeFromSuperview()
      }
    gameboardView.tiles.removeAll()
  }
  
  
  func hideAllTiles(animated a: Bool) {
    for tile in gameboardView.tiles.values {
      tile.disappear(animated: a)
    }
  }
  
  
  func setOpacity(to: Float) {
//    view.layer.opacity = to
    for v in gameboardView.subviews {
      v.layer.opacity = to
    }
  }
  
  
  func createTileView(tile: Tile, tileWidth: CGFloat, tilePadding: CGFloat) -> TileView {
    // Subract 1 as Tile starts count from 1, not 0.
    let xPosition = tilePadding + (tileWidth + tilePadding) * CGFloat(tile.col - 1)
    let yPosition = tilePadding + (tileWidth + tilePadding) * CGFloat(tile.row - 1)
    let tPosition = CGPoint(x: xPosition, y: yPosition)
    return TileView(position: tPosition, size: tileWidth, boardSize: uiData.gameBoardSize, text: tile.value ?? "Qr", uiData: uiData)
  }
  
  
  func selectTile(tileIndex: Int16) {
    gameboardView.tiles[tileIndex]?.tileSelected()
    if uiData.impact { UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.75) }
  }

  
  func deselectTile(tileIndex: Int16) {
    gameboardView.tiles[tileIndex]?.tileDeselected()
    if uiData.impact { UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.75) }
  }
  
  
  func getTileValue(tileIndex: Int16) -> String {
    return gameboardView.tiles[tileIndex]?.text ?? ""
  }


  func basicTilePositionFromCGPoint(point: CGPoint, tileSqrtFloat: CGFloat) -> Int16? {
    // Transforms a position point to a tile point.
    // Optional, as two checks:
    // 1. Going going outside the board.
    // 2. Indeterminate points between two tiles.
    
    let xPercent = point.x/uiData.gameBoardSize
    let yPercent = point.y/uiData.gameBoardSize
    
    guard (0 < xPercent && xPercent < 1 && 0 < yPercent && yPercent < 1) else {
      // Guard against going outside the board
      return nil
    }
    
    let xVal = xPercent * tileSqrtFloat
    let yVal = yPercent * tileSqrtFloat
    let xRemainder = xVal.truncatingRemainder(dividingBy: 1)
    let yRemainder = yVal.truncatingRemainder(dividingBy: 1)
    
    guard (0.25 < xRemainder && xRemainder < 0.75 && 0.25 < yRemainder && yRemainder < 0.75) else {
      // Guard against indeterminate points
      return nil
    }
    
    return Int16(xVal + 1) * 10 + Int16(yVal + 1)
  }
  

  func addGestureRecognizer(recogniser: UIGestureRecognizer) {
    gameboardView.addGestureRecognizer(recogniser)
  }
  
  
  func removeGestureRecognizer(recogniser: UIGestureRecognizer) {
    gameboardView.removeGestureRecognizer(recogniser)
  }
  
  
  func removeAllGestureRecognizers() {
    if gameboardView.gestureRecognizers != nil {
      for gr in gameboardView.gestureRecognizers! {
        gameboardView.removeGestureRecognizer(gr)
      }
    }
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
