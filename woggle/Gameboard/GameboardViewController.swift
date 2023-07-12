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
  
  let gameboardView: GameboardView
  let viewData: ViewData
  
  init(viewData vD: ViewData, tilePadding tP: CGFloat) {
    
    // Constants for placing elements
    viewData = vD

    // Setup the view
    gameboardView = GameboardView(boardSize: vD.gameBoardSize)
    gameboardView.backgroundColor = vD.colourD
    gameboardView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.frame.size = CGSize(width: viewData.gameBoardSize, height: viewData.gameBoardSize)
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
    let tilePadding = viewData.gameBoardSize * 0.01
    let tileWidth = (viewData.gameBoardSize - (tilePadding * (tileSqrtFloat + 1))) / tileSqrtFloat
    
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
    return TileView(position: tPosition, size: tileWidth, boardSize: viewData.gameBoardSize, text: tile.value ?? "Qr", viewData: viewData)
  }
  
  
  func selectTile(tileIndex: Int16) {
    gameboardView.tiles[tileIndex]?.tileSelected()
    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
  }

  
  func deselectTile(tileIndex: Int16) {
    gameboardView.tiles[tileIndex]?.tileDeselected()
    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
  }
  
  
  func getTileValue(tileIndex: Int16) -> String {
    return gameboardView.tiles[tileIndex]?.text ?? ""
  }


  func basicTilePositionFromCGPoint(point: CGPoint, tileSqrtFloat: CGFloat) -> Int16? {
    // Transforms a position point to a tile point.
    // Optional, as two checks:
    // 1. Going going outside the board.
    // 2. Indeterminate points between two tiles.
    
    let xPercent = point.x/viewData.gameBoardSize
    let yPercent = point.y/viewData.gameBoardSize
    
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
