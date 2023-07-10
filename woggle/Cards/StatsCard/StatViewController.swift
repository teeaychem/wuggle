//
//  StatViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/10.
//

import UIKit


class StatViewController: UIViewController {
  

  init(statID sID: String, viewData vD: ViewData) {
    
    super.init(nibName: nil, bundle: nil)
    
    view.backgroundColor = UIColor.red
    
    view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: vD.width * 0.9, height: vD.stopWatchSize))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
