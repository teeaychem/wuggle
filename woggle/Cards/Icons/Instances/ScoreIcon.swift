//
//  ScoreIcon.swift
//  woggle
//
//  Created by sparkes on 2023/07/08.
//

import UIKit


class ScoreIcon: IconView {
  
  var scoreLayer: CAShapeLayer?
  let scoreFont: UIFont
  let scoreLabel: UILabel
  
  
  init(size s: CGSize, abv: String) {
    
    scoreFont = UIFont(name: uiFontName, size: getFontFor(height: s.height * 0.65))!
    
    scoreLabel = UILabel(frame: CGRect(origin: CGPoint(x: s.width * 0.3, y: s.height * 0.2), size: CGSize(width: s.width * 0.6, height: s.height * 0.6)))
    
    
    
    super.init(size: s)
    
    let bPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: size.width * 0.1, y: size.height * 0.2), size: CGSize(width: size.width * 0.8, height: size.height * 0.6)), cornerRadius: radius)
    
    let bLayer = CAShapeLayer()
    bLayer.path = bPath.cgPath
    
    bLayer.fillColor = UIColor.lightGray.cgColor
//    bLayer.strokeColor = UIColor.black.cgColor
//    bLayer.lineWidth = 0.5
    
    layer.addSublayer(bLayer)
    
    scoreLabel.text = "0"
    scoreLabel.font = scoreFont
    scoreLabel.textColor = UIColor.darkGray
    scoreLabel.textAlignment = .center
    
    addSubview(scoreLabel)
    
    setAbv(abv: abv)
    updateIcon(value: "0")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setAbv(abv: String) {
    
    let abvLabel = UILabel(frame: CGRect(origin: CGPoint(x: size.width * 0.125, y: size.height * 0.2), size: CGSize(width: size.width * 0.2, height: size.height * 0.6)))
    abvLabel.text = abv
    abvLabel.font = scoreFont
    abvLabel.textColor = UIColor.darkGray
    abvLabel.textAlignment = .center
    
    addSubview(abvLabel)
  }
  
  
  override func updateIcon(value v: String) {
    scoreLabel.text = v
  }
  
}
