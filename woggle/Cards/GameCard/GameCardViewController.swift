//
//  GameCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit

class GameCardViewController: CardViewController {
  

  let boardViewController: GameboardViewController
  let stopwatchViewController: StopwatchViewController
  
  override init(viewData vD: CardViewData, settings s: Settings) {
    
    let gameBoardSizePercent = 0.95
    let gameBoardSize = vD.width * gameBoardSizePercent
    let boardPadding = vD.width * ((1 - gameBoardSizePercent)/2)
    let stopwatchSize = vD.height - ((3 * boardPadding) + gameBoardSize)
    
    boardViewController = GameboardViewController(boardSize: gameBoardSize, settings: s)
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
