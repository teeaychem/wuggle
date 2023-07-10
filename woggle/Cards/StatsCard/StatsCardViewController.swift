//
//  StatsCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/09.
//

import UIKit


class StatsCardViewController: CardViewController {
  
  
  let combinedScoreViewC: CombinedScoreViewController
  let mostPointsSVC: StatViewController
  let mostPercentSVC: StatViewController
  let mostWordsFoundSVC: StatViewController
  let highWordSVC: StatViewController
  let longestWordSVC: StatViewController
  
  override init(viewData vD: ViewData, delegate d: CardStackDelegate) {
    
    combinedScoreViewC = CombinedScoreViewController(size: vD.statusBarSize, viewData: vD)
    mostPointsSVC = StatViewController(statID: "mostPoints", viewData: vD)
    mostPercentSVC = StatViewController(statID: "mostPercent", viewData: vD)
    mostWordsFoundSVC = StatViewController(statID: "mostWordsFound", viewData: vD)
    highWordSVC = StatViewController(statID: "highWord", viewData: vD)
    longestWordSVC = StatViewController(statID: "longestWord", viewData: vD)
    
    super.init(viewData: vD, delegate: d)
    
    embed(combinedScoreViewC, inView: self.statusBarView, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: vD.statusBarSize))
    embed(mostPointsSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height), size: vD.statSize))
    embed(mostPercentSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height + vD.statSize.height), size: vD.statSize))
    embed(mostWordsFoundSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height + vD.statSize.height * 2), size: vD.statSize))
    embed(highWordSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height + vD.statSize.height * 3), size: vD.statSize))
    embed(longestWordSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height + vD.statSize.height * 4), size: vD.statSize))

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
