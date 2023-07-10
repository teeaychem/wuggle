//
//  StatsCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/09.
//

import UIKit


class StatsCardViewController: CardViewController {
  
  
  let combinedScoreViewC: CombinedScoreViewController
  let testState: StatViewController
  
  override init(viewData vD: ViewData, delegate d: CardStackDelegate) {
    
    combinedScoreViewC = CombinedScoreViewController(size: vD.statusBarSize, viewData: vD)
    testState = StatViewController(statID: "test", viewData: vD)
    
    super.init(viewData: vD, delegate: d)
    
    embed(combinedScoreViewC, inView: self.statusBarView, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: vD.statusBarSize))
    embed(testState, inView: self.view, frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
