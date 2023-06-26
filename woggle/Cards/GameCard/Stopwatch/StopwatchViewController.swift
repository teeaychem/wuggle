//
//  StopwatchViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/25.
//

import UIKit

class StopwatchViewController: UIViewController {
  
  private let size: CGFloat
  private let watchView: StopwatchView
  
  init(size s: CGFloat) {
    
    size = s
    watchView = StopwatchView(size: s)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(watchView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  

  
  
}
