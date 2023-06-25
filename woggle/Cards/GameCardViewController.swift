//
//  GameCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit

class GameCardViewController: CardViewController {
  

  let boardViewController: GameboardViewController
  
  override init(viewData vD: CardViewData, settings s: Settings) {
    
    boardViewController = GameboardViewController(boardSize: vD.width * 0.95, settings: s)
    
    super.init(viewData: vD, settings: s)
    
    self.embed(boardViewController, inView: self.view)
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  

  
  override func specificSetup() {
    print("okay")
//    let board = GameboardView(boardSize: )
  }
}
