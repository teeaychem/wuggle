//
//  ScoreIcon.swift
//  woggle
//
//  Created by sparkes on 2023/07/08.
//

import UIKit


class ScoreIcon: IconView {
  
  var scoreLayer: CAShapeLayer?
  
  
  override init(size s: CGFloat) {
    
    super.init(size: s)
    
    setScore(value: "0")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setScore(value v: String) {
    
    if scoreLayer != nil {
      scoreLayer!.removeFromSuperlayer()
    }
    
    scoreLayer = getStringLayers(text: v, font: UIFont(name: uiFontName, size: getFontFor(height: size * 0.9))!).first!
    scoreLayer!.bounds = scoreLayer!.path!.boundingBox
    scoreLayer!.fillColor = UIColor.black.cgColor
    
    scoreLayer!.frame.origin = CGPoint(x: size * 0.3, y: size * 0.3)
    
    layer.addSublayer(scoreLayer!)
  }
  
}
