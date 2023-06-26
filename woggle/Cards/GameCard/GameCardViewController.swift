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
    
    // TODO: XXXX
    currentGameInstace = s.getOrMakeCurrentGame()
    currentGameInstace!.populateBoard()
    print(currentGameInstace?.board)
    
    let gameBoardSizePercent = 0.95
    let gameBoardSize = vD.width * gameBoardSizePercent
    let boardPadding = vD.width * ((1 - gameBoardSizePercent)/2)
    let stopwatchSize = vD.height - ((3 * boardPadding) + gameBoardSize)
    
    
    boardViewController = GameboardViewController(boardSize: gameBoardSize, gameBoard: currentGameInstace!.board!)
    stopwatchViewController = StopwatchViewController(size: stopwatchSize)
    
    super.init(viewData: vD, settings: s)
    
    self.embed(boardViewController, inView: self.view)
    self.embed(stopwatchViewController, inView: self.view)
    
    // The view controller manages the view, but it's still up to us to place the view.
    // Position is relative to the CardView.
    
    boardViewController.view.frame.origin = CGPoint(x: boardPadding, y: vD.height - (gameBoardSize + boardPadding))
    // TODO: Shrink this for status bar
    stopwatchViewController.view.frame.origin = CGPoint(x: boardPadding, y: boardPadding)
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  

  
  override func specificSetup() {
    print("okay")
//    let board = GameboardView(boardSize: )
  }
}
