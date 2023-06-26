//
//  GameCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//
// Displays a card with the gameview.
// Primary settings are given by the card stack controller.
// On first run, request current game instance from settings.
// Load the board from the gameInstance, populate found words, fix timer.

// TODO: Timer
// TODO: Found words

import UIKit

class GameCardViewController: CardViewController {

  let boardViewController: GameboardViewController
  let stopwatchViewController: StopwatchViewController
  var currentGameInstace: GameInstance?
  
  override init(viewData vD: CardViewData, settings s: Settings) {
    
    // First, get a board to work with from settings.
    currentGameInstace = s.getOrMakeCurrentGame()
    
    // Constants to create and position views
    let gameBoardSizePercent = 0.95
    let gameBoardSize = vD.width * gameBoardSizePercent
    let boardPadding = vD.width * ((1 - gameBoardSizePercent)/2)
    let stopwatchSize = vD.height - ((3 * boardPadding) + gameBoardSize)
    
    // Fix controllers for the current views
    boardViewController = GameboardViewController(boardSize: gameBoardSize, gameBoard: currentGameInstace!.board!)
    stopwatchViewController = StopwatchViewController(size: stopwatchSize)
    
    super.init(viewData: vD, settings: s)
    
    // Embed controllers with views


    // Position views
    boardViewController.view.frame.origin = CGPoint(x: boardPadding, y: vD.height - (gameBoardSize + boardPadding))
    // TODO: Shrink this for status bar
    stopwatchViewController.view.frame.origin = CGPoint(x: boardPadding, y: boardPadding)
    
    // TODO: Set the initial board view
    boardViewController.gameboardView.displayTileViews()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.embed(boardViewController, inView: self.view)
//    self.embed(stopwatchViewController, inView: self.view)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
