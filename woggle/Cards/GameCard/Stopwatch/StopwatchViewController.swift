//
//  StopwatchViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/25.
//

import UIKit

class StopwatchViewController: UIViewController {
  
  private let size: CGFloat
  private let viewData: ViewData
  let watchView: StopwatchView
  
  init(viewData vD: ViewData) {
    
    viewData = vD
    size = vD.stopWatchSize
    watchView = StopwatchView(viewData: vD)
    
    watchView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(watchView)
    paintStatic()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
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
  
  func setHandTo(percent: Double) {
    // Argument is %, so angle is % of 2pi.
    watchView.setSecondTo(angle: percent * (2 * Double.pi))
  }
  
  
  func incrementHandBy(percent: Double) {
    // Argument is %, so angle is % of 2pi.
    watchView.incrementSeconds(updateAngleIncrement: percent * (2 * Double.pi))
  }
  
  
  func resetHand() {
    watchView.resetSeconds()
  }
  
  
  func removeAllGestureRecognizers() {
    if view.gestureRecognizers != nil {
      for gr in view.gestureRecognizers! {
        view.removeGestureRecognizer(gr)
      }
    }
  }
  
}
