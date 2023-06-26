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
  
  init(boardSize bS: CGFloat, gameBoard: Board) {
    
    // Constants for placing elements
    boardSize = bS
    
    let tileSqrtFloat = CGFloat(gameBoard.tiles!.count).squareRoot()
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
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    gameboardView.addGestureRecognizer(panGestureRecognizer)
  }
  
  override func viewDidLayoutSubviews() {
    // Before this is called the frame of the view has not been set.
    // So, this seems to be the appropriate place to fix things.
    // https://stackoverflow.com/questions/40737164/whats-exactly-viewdidlayoutsubviews
    super.viewDidLayoutSubviews()
    view.frame.size = CGSize(width: boardSize, height: boardSize)
  }
  
  func createAllTileViews(board: Board) {
    for tile in board.tiles! {
      let newTile = createTileView(tile: tile as! Tile)
      gameboardView.addTileSubview(tileView: newTile)
    }
  }
  
  func createTileView(tile: Tile) -> TileView {
    let xPosition = tilePadding + (tileWidth + tilePadding) * CGFloat(tile.row)
    let yPosition = tilePadding + (tileWidth + tilePadding) * CGFloat(tile.col)
    let tPosition = CGPoint(x: xPosition, y: yPosition)
    return TileView(position: tPosition, size: tileWidth, boardSize: boardSize, text: tile.value ?? "Qr")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func didPan(_ sender: UIPanGestureRecognizer) {
    print(sender.location(in: view))
  }
}
