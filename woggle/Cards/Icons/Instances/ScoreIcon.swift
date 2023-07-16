//
//  ScoreIcon.swift
//  woggle
//
//  Created by sparkes on 2023/07/08.
//

import UIKit


class ScoreIcon: IconView {
  
  private let gameCard: Bool
  
  private let borderLayer = CAShapeLayer()
  private let scoreFont: UIFont
  private let scoreLabel: UILabel
  private var textAttributes: [NSAttributedString.Key : Any]?
  
  init(uiData uiD: UIData, abv: String, gameCard g: Bool) {
    
    gameCard = g
    
    scoreFont = UIFont(name: uiFontName, size: getFontFor(height: uiD.scoreIconSize.height * 0.7))!
    
    scoreLabel = UILabel(frame: CGRect(origin: CGPoint(x: uiD.scoreIconSize.width * 0.3, y: uiD.scoreIconSize.height * 0.175), size: CGSize(width: uiD.scoreIconSize.width * 0.6, height: uiD.scoreIconSize.height * 0.6)))
    
    
    super.init(size: uiD.scoreIconSize, uiData: uiD)
    
    borderLayer.path = getBorderPath()
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.lineWidth = 0.5
    
    if gameCard {
      borderLayer.strokeColor = uiD.colourD.cgColor
      textAttributes = uiD.getSettingsTextAttribute(height: size.height * 0.8, colour: uiD.colourD.cgColor)
    } else {
      borderLayer.strokeColor = uiD.colourM.cgColor
      textAttributes = uiD.getSettingsTextAttribute(height: size.height * 0.8, colour: uiD.colourM.cgColor)
    }
    scoreLabel.attributedText = NSMutableAttributedString(string: "0", attributes: textAttributes)
    scoreLabel.textAlignment = .center
    
    layer.addSublayer(borderLayer)
    addSubview(scoreLabel)
    
    setAbv(abv: abv)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setAbv(abv: String) {
    
    let abvLabel = UILabel(frame: CGRect(origin: CGPoint(x: size.width * 0, y: size.height * 0.175), size: CGSize(width: size.width * 0.3, height: size.height * 0.6)))
//    abvLabel.text = abv
    abvLabel.font = scoreFont
    abvLabel.textColor = uiData.colourD
    abvLabel.textAlignment = .center
    
    abvLabel.attributedText = NSMutableAttributedString(string: abv, attributes: textAttributes)
    
    addSubview(abvLabel)
  }
  
  
  private func getBorderPath() -> CGPath {
    
    return UIBezierPath(
      roundedRect: CGRect(
        origin: CGPoint(x: 0, y: frame.height * 0.1),
        size: CGSize(width: size.width, height: size.height * 0.8)),
      cornerRadius: 5)
    .cgPath
  }
  
  
  override func updateIcon(value v: Int16) {
    if v > -1 {
      scoreLabel.attributedText = NSMutableAttributedString(string: String(v), attributes: textAttributes)
    } else {
      scoreLabel.attributedText = NSMutableAttributedString(string: "~", attributes: textAttributes)
    }
  }
  
}
