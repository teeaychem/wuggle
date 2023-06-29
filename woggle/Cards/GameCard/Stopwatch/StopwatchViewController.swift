//
//  StopwatchViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/25.
//

import UIKit

class StopwatchViewController: UIViewController {
  
  private let size: CGFloat
  private let viewData: CardViewData
  let watchView: StopwatchView
  
  init(viewData vD: CardViewData) {
    
    viewData = vD
    size = vD.stopWatchSize()
    watchView = StopwatchView(viewData: vD)
    
    watchView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize())
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(watchView)
    paintStatic()
  }
  
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.frame.size = watchView.frame.size
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func paintStatic() {
    watchView.paintWatchBackground()
    watchView.paintFaceLayer()
  }
  
  
  func paintSeconds() {
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
