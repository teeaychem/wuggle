//
//  StopwatchViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/25.
//

import UIKit

class StopwatchViewController: UIViewController {
  
  private let size: CGFloat
  let watchView: StopwatchView
  private let secondsIncrement: Double
  
  init(viewData vD: CardViewData, gameInstance gI: GameInstance) {
    
    size = vD.stopWatchSize()
    watchView = StopwatchView(size: size)
    secondsIncrement = (2 * Double.pi) / (gI.settings!.time + 1)
    
    watchView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize())
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(watchView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func addSeconds() {
    watchView.addSeconds()
  }
  
  
  func addRestartArrow() {
    print("arrow")
    watchView.addRestartArrows()
  }
  
  func incrementHand(percent: Double) {
    watchView.incrementSeconds(updateAngleIncrement: percent)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame.size = CGSize(width: size, height: size)
  }

  
  
}
