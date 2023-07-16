//
//  StopwatchViewController.swift
//  wuggle
//
//  Created by sparkes on 2023/06/25.
//

import UIKit

class StopwatchViewController: UIViewController {
  
  private let size: CGFloat
  private let uiData: UIData
  let watchView: StopwatchView
  
  init(uiData uiD: UIData) {
    
    uiData = uiD
    size = uiD.stopWatchSize
    watchView = StopwatchView(uiData: uiD)
    
    watchView.layer.cornerRadius = getCornerRadius(width: uiD.gameBoardSize)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(watchView)
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame.size = watchView.frame.size
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setHandTo(percent: Double) {
    // Argument is %, so angle is % of 2pi.
    watchView.makeSecondHandTo(angle: percent * (2 * Double.pi))
  }
  
  
  func incrementHandBy(percent: Double) {
    // Argument is %, so angle is % of 2pi.
    if percent > 0 {
      watchView.incrementSecondHand(toAngleIncrement: percent * (2 * Double.pi))
    } else {
      // Rotate once per minute.
      watchView.incrementSecondHand(toAngleIncrement: percent * 1/60 * (2 * Double.pi))
    }
  }

  
  
  func removeAllGestureRecognizers() {
    if view.gestureRecognizers != nil {
      for gr in view.gestureRecognizers! {
        view.removeGestureRecognizer(gr)
      }
    }
  }
  
}
