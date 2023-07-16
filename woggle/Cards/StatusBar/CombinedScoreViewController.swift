//
//  CombinedScoreViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/10.
//

import UIKit

class CombinedScoreViewController: UIViewController {
  
  private let foundIcon: IconView
  private let scoreIcon: IconView
  private let perceIcon: IconView
  private let uiData: UIData
  
  init(uiData uiD: UIData, gameCard g: Bool) {
    
    foundIcon = ScoreIcon(uiData: uiD, abv: "W", gameCard: g)
    scoreIcon = ScoreIcon(uiData: uiD, abv: "P", gameCard: g)
    perceIcon = ScoreIcon(uiData: uiD, abv: "%", gameCard: g)
    uiData = uiD
    
    super.init(nibName: nil, bundle: nil)
    
    view.bounds.size = uiD.statusBarSize
  }
  
  override func viewDidLoad() {
    view.addSubview(foundIcon)
    view.addSubview(scoreIcon)
    view.addSubview(perceIcon)
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    view.frame.size = CGSize(width: foundIcon.size.width * 10/3, height: foundIcon.size.height)
    
    let sBIconIndent = (view.frame.width - (3 * foundIcon.frame.width)) * 0.25
    foundIcon.frame.origin = CGPoint(x: sBIconIndent, y: 0)
    scoreIcon.frame.origin = CGPoint(x: (sBIconIndent * 2) + foundIcon.frame.width, y: 0)
    perceIcon.frame.origin = CGPoint(x: (sBIconIndent * 3) + foundIcon.frame.width * 2, y: 0)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func updateFound(val: Int16) {
    foundIcon.updateIcon(value: val)
  }
  
  
  func updateScore(val: Int16) {
    scoreIcon.updateIcon(value: val)
  }
  
  
  func updatePercent(val: Int16) {
    perceIcon.updateIcon(value: val)
  }
  
  
  func combinedUpdate(found: Int16, score: Int16, percent: Int16, obeySP: Bool) {
    updateFound(val: found)
    updateScore(val: score)
    (obeySP && !uiData.showPercent) ? updatePercent(val: -1) : updatePercent(val: percent)
  }
  
  
  func gameInstanceUpdate(instance: GameInstance, obeySP: Bool) {
    updateFound(val: instance.foundWordCount)
    updateScore(val: instance.pointsCount)
    
    if (obeySP && uiData.showPercent) {
      let percent = (Double(instance.foundWordCount) / Double(instance.allWordsList!.count)) * 100
      updatePercent(val: Int16(percent))
    } else {
      updatePercent(val: -1)
    }
  }
  
  
}
