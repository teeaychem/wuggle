//
//  StatViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/10.
//

import UIKit


class StatViewController: UIViewController {
  
  // TODO: Instead of stat + board, I want to have just stat, and when this is selected, show a large board.
  // This way, the board should be large enough to easily see.
  // Half the size of the main board might work.
  // But, then there's a lot of empty space.
  // Alternatively, hold down on the stat and see the board.
  // This works, except I only have maybe half.
  // And, double line doesn't feel good.
  // Instead, for longest word, implement shrink to width.
  // So, heterogram.
  // Highest Points/length ratio.
  // Lowest points/length ratio.
  // Oh, I can double and add the date.
  // So, with these suggestions, I have 8 + date.
  // This, then, is the plan.
  
  
//  let gameBoardVC: GameboardViewController
  

  init(statID sID: String, viewData vD: ViewData) {
    
//    gameBoardVC = GameboardViewController(boardSize: vD.statSize.height * 0.95, viewData: vD, tilePadding: 1)
//
    super.init(nibName: nil, bundle: nil)
//
//    view.backgroundColor = UIColor.gray
//    view.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize * 0.5)
//
//    view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: vD.width * 0.95, height: vD.stopWatchSize))
//    embed(gameBoardVC, inView: self.view, frame: CGRect(x: vD.statSize.width - vD.statSize.height, y: vD.statSize.height * 0.025, width: vD.statSize.height * 0.95, height: vD.statSize.height * 0.95))
//    gameBoardVC.view.backgroundColor = UIColor.blue
//    gameBoardVC.addGameboardView()
//
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let testSettings = Settings(context: context)
//    testSettings.setNewGame()
//    testSettings.currentGame?.populateBoard()
//
//    gameBoardVC.createAllTileViews(board: testSettings.currentGame!.board!)
//    gameBoardVC.displayAllTiles()
//    gameBoardVC.gameboardView.displayTileViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
