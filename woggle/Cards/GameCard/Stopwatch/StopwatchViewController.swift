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
  
  init(viewData vD: CardViewData) {
    
    size = vD.stopWatchSize()
    watchView = StopwatchView(size: size)
    
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
  
  
  func incrementHand(percent: Double) {
    watchView.incrementSeconds(updateAngleIncrement: percent)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame.size = CGSize(width: size, height: size)
  }

  
  
}
