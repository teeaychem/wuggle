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
  let bestPLRationSVC: StatViewController
  
  override init(viewData vD: ViewData, delegate d: CardStackDelegate) {
    
    combinedScoreViewC = CombinedScoreViewController(size: vD.statusBarSize, viewData: vD)
    mostPointsSVC = StatViewController(statID: "mostPoints", viewData: vD)
    mostPercentSVC = StatViewController(statID: "mostPercent", viewData: vD)
    mostWordsFoundSVC = StatViewController(statID: "mostWordsFound", viewData: vD)
    highWordSVC = StatViewController(statID: "highWord", viewData: vD)
    longestWordSVC = StatViewController(statID: "longestWord", viewData: vD)
    bestPLRationSVC = StatViewController(statID: "longestWord", viewData: vD)
    
    super.init(viewData: vD, delegate: d)
    
    let statVSep = (vD.height - (vD.statusBarSize.height + vD.statSize.height * 6)) / 7
    
    embed(combinedScoreViewC, inView: self.statusBarView, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: vD.statusBarSize))
    
    embed(mostPointsSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height + statVSep), size: vD.statSize))
    
    embed(mostPercentSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height + vD.statSize.height + statVSep * 2), size: vD.statSize))
    
    embed(mostWordsFoundSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height + vD.statSize.height * 2 + statVSep * 3), size: vD.statSize))
   
    embed(highWordSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height + vD.statSize.height * 3 + statVSep * 4), size: vD.statSize))
    
    embed(longestWordSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height + vD.statSize.height * 4 + statVSep * 5), size: vD.statSize))
    
    embed(bestPLRationSVC, inView: self.view, frame: CGRect(origin: CGPoint(x: vD.width * 0.025, y: vD.statusBarSize.height + vD.statSize.height * 5 + statVSep * 6), size: vD.statSize))

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
