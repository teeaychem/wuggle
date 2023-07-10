//
//  StatsCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/09.
//

import UIKit


class StatsCardViewController: CardViewController {
  
  
  let foundIcon: IconView
  let scoreIcon: IconView
  let perceIcon: IconView
  
  override init(viewData vD: CardViewData, delegate d: CardStackDelegate) {
    
    // Icons
    foundIcon = ScoreIcon(size: vD.scoreIconSize, abv: "W")
    scoreIcon = ScoreIcon(size: vD.scoreIconSize, abv: "P")
    perceIcon = ScoreIcon(size: vD.scoreIconSize, abv: "%")
    
    super.init(viewData: vD, delegate: d)
    
    let sBIconIndent = (statusBarView.frame.width - (3 * vD.scoreIconSize.width)) * 0.25
    statusBarView.addSubview(foundIcon)
    statusBarView.addSubview(scoreIcon)
    statusBarView.addSubview(perceIcon)
    foundIcon.frame.origin = CGPoint(x: sBIconIndent, y: 0)
    scoreIcon.frame.origin = CGPoint(x: (sBIconIndent * 2) + vD.scoreIconSize.width, y: 0)
    perceIcon.frame.origin = CGPoint(x: (sBIconIndent * 3) + vD.scoreIconSize.width * 2, y: 0)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
