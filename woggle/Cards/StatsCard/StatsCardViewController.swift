//
//  StatsCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/09.
//

import UIKit


class StatsCardViewController: CardViewController {
  
  
  let combinedScoreViewC: CombinedScoreViewController
  
  override init(viewData vD: CardViewData, delegate d: CardStackDelegate) {
    
    combinedScoreViewC = CombinedScoreViewController(size: vD.statusBarSize, viewData: vD)
    
    super.init(viewData: vD, delegate: d)
    
    embed(combinedScoreViewC, inView: self.statusBarView, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: vD.statusBarSize))
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
