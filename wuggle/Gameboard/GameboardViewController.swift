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
// To help pass this information around, this pair is combined to an Int16 by x + (y * 4).
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
  
  
  func tileLocationCombine(x: Int, y: Int, sqrt: Int) -> Int {
    return x + (y * sqrt)
  }
  
  
  func tileLocationSplit(combined: Int, sqrt: Int) -> (Int, Int) {
    let qr = combined.quotientAndRemainder(dividingBy: sqrt)
    return (qr.remainder, qr.quotient)
  }
  
  
  func createAllTileViews(tileValues: [String], tileSqrt tS: Int) {
    
    removeAllTileViews()
    
    let tilePadding = uiData.gameBoardSize * 0.01
    let tileWidth = (uiData.gameBoardSize - (tilePadding * CGFloat(tS + 1))) / CGFloat(tS)
    
    for i in 0 ..< tileValues.count {
      let newTile = createTileView(tileIndex: i, tileSqrt: tS, tileValue: tileValues[i], tileWidth: tileWidth, tilePadding: tilePadding)
      gameboardView.addTileSubview(tileKey: i, tileView: newTile)
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
  
  
  func createTileView(tileIndex tI: Int, tileSqrt tS: Int, tileValue: String, tileWidth: CGFloat, tilePadding: CGFloat) -> TileView {
    let tileSplit = splitTile(index: tI, tileSqrt: tS)
    
    let xPosition = tilePadding + ((tileWidth + tilePadding) * CGFloat(tileSplit.0))
    let yPosition = tilePadding + ((tileWidth + tilePadding) * CGFloat(tileSplit.1))
    let tPosition = CGPoint(x: xPosition, y: yPosition)
    return TileView(position: tPosition, size: tileWidth, boardSize: uiData.gameBoardSize, text:  tileValue, uiData: uiData)
  }
  
  
  func selectTile(tileIndex: Int) {
    gameboardView.tiles[tileIndex]?.tileSelected()
    if uiData.impact { UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.75) }
  }
  
  
  func dimTile(tileIndex: Int) {
    gameboardView.tiles[tileIndex]?.dim()
  }

  
  func deselectTile(tileIndex: Int) {
    gameboardView.tiles[tileIndex]?.tileDeselected()
    if uiData.impact { UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.75) }
  }
  
  
  func getTileValue(tileIndex: Int) -> String {
    return gameboardView.tiles[tileIndex]?.text ?? ""
  }


  func basicTilePositionFromCGPoint(point: CGPoint, tileSqrtFloat: CGFloat) -> Int? {
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
    
    return tileLocationCombine(x: Int(xVal), y: Int(yVal), sqrt: Int(tileSqrtFloat))
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


// TODO: Move this somewhere

func splitTile(index: Int, tileSqrt: Int) -> (Int, Int) {
  let qr = index.quotientAndRemainder(dividingBy: tileSqrt)
  return (qr.remainder, qr.quotient)
}
