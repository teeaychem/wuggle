//
//  CombinedScoreViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/10.
//

import UIKit

class CombinedScoreViewController: UIViewController {
  
  let scoreFont: UIFont
  var textAttributes: [NSAttributedString.Key : Any]?
  let sepColor: UIColor
  
  let foundIcon: IconView
  let scoreIcon: IconView
  let perceIcon: IconView
  
  init(size s: CGSize, viewData vD: ViewData) {
    
    scoreFont = UIFont(name: uiFontName, size: getFontFor(height: s.height * 0.7))!
    sepColor = vD.colourL
    
    foundIcon = ScoreIcon(size: vD.scoreIconSize, viewData: vD, abv: "W")
    scoreIcon = ScoreIcon(size: vD.scoreIconSize, viewData: vD, abv: "P")
    perceIcon = ScoreIcon(size: vD.scoreIconSize, viewData: vD, abv: "%")
    
    super.init(nibName: nil, bundle: nil)
    
  }
  
  override func viewDidLoad() {
    let sBIconIndent = (view.frame.width - (3 * foundIcon.frame.width)) * 0.25
    
    view.addSubview(foundIcon)
    view.addSubview(scoreIcon)
    view.addSubview(perceIcon)
    foundIcon.frame.origin = CGPoint(x: sBIconIndent, y: 0)
    scoreIcon.frame.origin = CGPoint(x: (sBIconIndent * 2) + foundIcon.frame.width, y: 0)
    perceIcon.frame.origin = CGPoint(x: (sBIconIndent * 3) + foundIcon.frame.width * 2, y: 0)
    
    addSeperator(xPos: foundIcon.frame.minX)
    addSeperator(xPos: scoreIcon.frame.minX)
    addSeperator(xPos: perceIcon.frame.minX)

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func addSeperator(xPos: CGFloat) {
    
    let sepPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: foundIcon.frame.height * 0.1), size: CGSize(width: foundIcon.size.width, height: foundIcon.size.height * 0.8)), cornerRadius: 5)
    let sepLayer = CAShapeLayer()
    sepLayer.path = sepPath.cgPath
    sepLayer.fillColor = UIColor.clear.cgColor
    sepLayer.strokeColor = sepColor.cgColor
    sepLayer.lineCap = .round
    sepLayer.lineWidth = 0.5
    
    
    sepLayer.frame.origin = CGPoint(x: xPos, y: 0)
    
    view.layer.addSublayer(sepLayer)
  }
  
  
  func updateFound(val: Int16) {
    foundIcon.updateIcon(value: String(val))
  }
  
  
  func updateScore(val: Int16) {
    scoreIcon.updateIcon(value: String(val))
  }
  
  
  func updatePercent(val: Int16) {
    perceIcon.updateIcon(value: String(val))
  }
  
  
  func combinedUpdate(found: Int16, score: Int16, percent: Int16) {
    updateFound(val: found)
    updateScore(val: score)
    updatePercent(val: percent)
  }
  
  
  func gameInstanceUpdate(instance: GameInstance) {
    updateFound(val: instance.foundWordCount)
    updateScore(val: instance.pointsCount)
    updatePercent(val: 0)
  }
  
  
}
