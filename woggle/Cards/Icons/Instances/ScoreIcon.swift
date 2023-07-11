//
//  ScoreIcon.swift
//  woggle
//
//  Created by sparkes on 2023/07/08.
//

import UIKit


class ScoreIcon: IconView {
  
  let borderLayer = CAShapeLayer()
  var scoreLayer: CAShapeLayer?
  let scoreFont: UIFont
  let scoreLabel: UILabel
  var textAttributes: [NSAttributedString.Key : Any]?
  
  
  init(size s: CGSize, viewData vD: ViewData, abv: String) {
    
    scoreFont = UIFont(name: uiFontName, size: getFontFor(height: s.height * 0.7))!
    
    scoreLabel = UILabel(frame: CGRect(origin: CGPoint(x: s.width * 0.3, y: s.height * 0.175), size: CGSize(width: s.width * 0.6, height: s.height * 0.6)))
    
    
    super.init(size: s, viewData: vD)
    
    
    borderLayer.path = getBorderPath()
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.strokeColor = UIColor.white.cgColor
    borderLayer.lineWidth = 0.5

    
    textAttributes = vD.getSettingsTextAttribute(height: size.height * 0.8, colour: vD.colourD.cgColor)
    scoreLabel.attributedText = NSMutableAttributedString(string: "0", attributes: textAttributes)
    scoreLabel.textAlignment = .center
    
    layer.addSublayer(borderLayer)
    addSubview(scoreLabel)
    
    setAbv(abv: abv)
    updateIcon(value: "0")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setAbv(abv: String) {
    
    let abvLabel = UILabel(frame: CGRect(origin: CGPoint(x: size.width * 0, y: size.height * 0.175), size: CGSize(width: size.width * 0.3, height: size.height * 0.6)))
//    abvLabel.text = abv
    abvLabel.font = scoreFont
    abvLabel.textColor = UIColor.darkGray
    abvLabel.textAlignment = .center
    
    abvLabel.attributedText = NSMutableAttributedString(string: abv, attributes: textAttributes)
    
    addSubview(abvLabel)
  }
  
  
  private func getBorderPath() -> CGPath {
    
    return UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: frame.height * 0.1), size: CGSize(width: size.width, height: size.height * 0.8)), cornerRadius: 5).cgPath
  }
  
  
  override func updateIcon(value v: String) {
    scoreLabel.attributedText = NSMutableAttributedString(string: v, attributes: textAttributes)
  }
  
}
