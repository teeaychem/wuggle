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
  let statVSep: CGFloat
  let statXOrigin: CGFloat
  
  override init(viewData vD: ViewData, delegate d: CardStackDelegate) {
    
    statVSep = (vD.height - (vD.statusBarSize.height + vD.statSize.height * 6)) / 7
    statXOrigin = vD.width * 0.025
    
    combinedScoreViewC = CombinedScoreViewController(size: vD.statusBarSize, viewData: vD)
    mostPointsSVC = StatViewController(stat: d.currentStats().topPoints!, displayName: "Most points", viewData: vD)
    mostPercentSVC = StatViewController(stat: d.currentStats().topPercent!, displayName: "Highest % found", viewData: vD)
    mostWordsFoundSVC = StatViewController(stat: d.currentStats().topWords!, displayName: "Most words found", viewData: vD)
    highWordSVC = StatViewController(stat: d.currentStats().topWordPoints!, displayName: "Top scoring word", viewData: vD)
    longestWordSVC = StatViewController(stat: d.currentStats().topWordLength!, displayName: "Longest word", viewData: vD)
    bestPLRationSVC = StatViewController(stat: d.currentStats().topRatio!, displayName: "Best points:length", viewData: vD)
    
    
    super.init(viewData: vD, delegate: d)
      
    embed(combinedScoreViewC, inView: self.statusBarView, origin: CGPoint(x: 0, y: 0))
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  
  override func broughtToTop() {
    super.broughtToTop()
    
    embed(mostPointsSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: statVSep))
    embed(mostPercentSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: mostPointsSVC.view.frame.maxY + statVSep))
    embed(mostWordsFoundSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: mostPercentSVC.view.frame.maxY + statVSep))
    embed(highWordSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: mostWordsFoundSVC.view.frame.maxY + statVSep))
    embed(longestWordSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: highWordSVC.view.frame.maxY + statVSep))
    embed(bestPLRationSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: longestWordSVC.view.frame.maxY + statVSep))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
