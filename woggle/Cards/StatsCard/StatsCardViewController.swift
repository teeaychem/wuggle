//
//  StatsCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/09.
//

import UIKit


class StatsCardViewController: CardViewController {
  
  var combinedScoreViewC: CombinedScoreViewController
  
  var statVCs = [String: StatViewController]()

  let statVSep: CGFloat
  let statXOrigin: CGFloat
  
  override init(iName iN: String, uiData uiD: UIData, delegate d: CardStackDelegate) {
    
    statVSep = (uiD.cardSize.height - (uiD.statusBarSize.height + uiD.statSize.height * 6)) / 7
    statXOrigin = uiD.cardSize.width * 0.025
    
    combinedScoreViewC = CombinedScoreViewController(uiData: uiD, gameCard: false)
    statVCs["mostWordsFound"] = StatViewController(stat: d.currentStats().topWords!, displayName: "Most Words Found", uiData: uiD)
    statVCs["mostPoints"] = StatViewController(stat: d.currentStats().topPoints!, displayName: "Most Points Collected", uiData: uiD)
    statVCs["mostPercent"] = StatViewController(stat: d.currentStats().topPercent!, displayName: "Highest % Found", uiData: uiD)
    statVCs["highWord"] = StatViewController(stat: d.currentStats().topWordPoints!, displayName: "Top Scoring Word", uiData: uiD)
    statVCs["longestWord"] = StatViewController(stat: d.currentStats().topWordLength!, displayName: "Longest Word", uiData: uiD)
    statVCs["bestPLRation"] = StatViewController(stat: d.currentStats().topRatio!, displayName: "Best Points-Length Ratio", uiData: uiD)
    
    
    super.init(iName: iN, uiData: uiD, delegate: d)
      
    embed(combinedScoreViewC, inView: self.statusBarView, origin: CGPoint(x: 0, y: 0))
    combinedScoreViewC.combinedUpdate(found: Int16(d.currentStats().topWords!.numVal), score: Int16(d.currentStats().topPoints!.numVal), percent: Int16(d.currentStats().topPercent!.numVal), obeySP: false)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  
  override func broughtToTop() {
    super.broughtToTop()

    statVCs["mostPoints"]!.updateWith(stat: delegate!.currentStats().topPoints!)
    statVCs["mostPercent"]!.updateWith(stat: delegate!.currentStats().topPercent!)
    statVCs["mostWordsFound"]!.updateWith(stat: delegate!.currentStats().topWords!)
    statVCs["highWord"]!.updateWith(stat: delegate!.currentStats().topWordPoints!)
    statVCs["longestWord"]!.updateWith(stat: delegate!.currentStats().topWordLength!)
    statVCs["bestPLRation"]!.updateWith(stat: delegate!.currentStats().topRatio!)
    
    embed(statVCs["mostWordsFound"]!, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: statVSep))
    embed(statVCs["mostPoints"]!, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: statVCs["mostWordsFound"]!.view.frame.maxY + statVSep))
    embed(statVCs["mostPercent"]!, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: statVCs["mostPoints"]!.view.frame.maxY + statVSep))
    embed(statVCs["highWord"]!, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: statVCs["mostPercent"]!.view.frame.maxY + statVSep))
    embed(statVCs["longestWord"]!, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: statVCs["highWord"]!.view.frame.maxY + statVSep))
    embed(statVCs["bestPLRation"]!, inView: self.mainView, origin: CGPoint(x: statXOrigin, y: statVCs["longestWord"]!.view.frame.maxY + statVSep))
  }
  
  override func shuffledToDeck() {
    for viewC in statVCs.values { unembed(viewC, inView: self.mainView) }
    super.shuffledToDeck()
  }
  
  
  override func respondToUpdate() {
    combinedScoreViewC.combinedUpdate(
      found: Int16(delegate!.currentStats().topWords!.numVal),
      score: Int16(delegate!.currentStats().topPoints!.numVal),
      percent: Int16(delegate!.currentStats().topPercent!.numVal), obeySP: false)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
