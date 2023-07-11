//
//  StatsCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/09.
//

import UIKit


class StatsCardViewController: CardViewController {
  
  var combinedScoreViewC: CombinedScoreViewController
  var mostPointsSVC: StatViewController
  var mostPercentSVC: StatViewController
  var mostWordsFoundSVC: StatViewController
  var highWordSVC: StatViewController
  var longestWordSVC: StatViewController
  var bestPLRationSVC: StatViewController
  let statVSep: CGFloat
  let statXOrigin: CGFloat
  
  override init(viewData vD: ViewData, delegate d: CardStackDelegate) {
    
    statVSep = (vD.height - (vD.statusBarSize.height + vD.statSize.height * 6)) / 7
    statXOrigin = vD.width * 0.025
    
    combinedScoreViewC = CombinedScoreViewController(size: vD.statusBarSize, viewData: vD)
    mostPointsSVC = StatViewController(stat: d.currentStats().topPoints!, displayName: "Most Words Found", viewData: vD)
    mostPercentSVC = StatViewController(stat: d.currentStats().topPercent!, displayName: "Most Points Collected", viewData: vD)
    mostWordsFoundSVC = StatViewController(stat: d.currentStats().topWords!, displayName: "Highest % Found", viewData: vD)
    highWordSVC = StatViewController(stat: d.currentStats().topWordPoints!, displayName: "Top Scoring Word", viewData: vD)
    longestWordSVC = StatViewController(stat: d.currentStats().topWordLength!, displayName: "Longest Word", viewData: vD)
    bestPLRationSVC = StatViewController(stat: d.currentStats().topRatio!, displayName: "Best Points-Length Ratio", viewData: vD)
    
    
    super.init(viewData: vD, delegate: d)
      
    embed(combinedScoreViewC, inView: self.statusBarView, origin: CGPoint(x: 0, y: 0))
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  
  override func broughtToTop() {
    super.broughtToTop()
    

    mostPointsSVC.updateWith(stat: delegate!.currentStats().topPoints!)
    mostPercentSVC.updateWith(stat: delegate!.currentStats().topPercent!)
    mostWordsFoundSVC.updateWith(stat: delegate!.currentStats().topWords!)
    highWordSVC.updateWith(stat: delegate!.currentStats().topWordPoints!)
    longestWordSVC.updateWith(stat: delegate!.currentStats().topWordLength!)
    bestPLRationSVC.updateWith(stat: delegate!.currentStats().topRatio!)
    
    embed(mostPointsSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: statVSep))
    embed(mostPercentSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: mostPointsSVC.view.frame.maxY + statVSep))
    embed(mostWordsFoundSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: mostPercentSVC.view.frame.maxY + statVSep))
    embed(highWordSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: mostWordsFoundSVC.view.frame.maxY + statVSep))
    embed(longestWordSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: highWordSVC.view.frame.maxY + statVSep))
    embed(bestPLRationSVC, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: longestWordSVC.view.frame.maxY + statVSep))
  }
  
  
  override func shuffledToDeck() {
    unembed(mostPointsSVC, inView: self.mainView)
    unembed(mostPercentSVC, inView: self.mainView)
    unembed(mostWordsFoundSVC, inView: self.mainView)
    unembed(highWordSVC, inView: self.mainView)
    unembed(longestWordSVC, inView: self.mainView)
    unembed(bestPLRationSVC, inView: self.mainView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
