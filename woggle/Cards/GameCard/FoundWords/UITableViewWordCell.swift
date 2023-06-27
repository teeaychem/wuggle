//
//  UITableViewWordCell.swift
//  buggle
//
//  Created by Benjamin Sparkes on 13/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit

class UITableViewWordCell : UITableViewCell {
  
  private let wordText: String
  private let width : CGFloat
  private var WordTextLabel = UILabel()
  private var PointsLabel = UILabel()
  
  init(style s : UITableViewCell.CellStyle, reuseIdentifier r: String?, word w: GameWord, width gw: CGFloat, height h: CGFloat, shadeWords sh: Bool) {
    wordText = w.value!.capitalized
    width = gw
    
    super.init(style: s, reuseIdentifier: r)
    
    backgroundColor = UIColor.clear
    
    let labelFontSize =  h*0.8
    let fontYOffset = h - labelFontSize/2 - (h - labelFontSize)/2
    
    var wordTextAttributes: [NSAttributedString.Key : Any]
    
    if sh && w.found {
      wordTextAttributes = [
        NSAttributedString.Key.strokeColor : reguardTextShaded,
        NSAttributedString.Key.foregroundColor : reguardTextShaded,
        NSAttributedString.Key.strokeWidth : -1,
        NSAttributedString.Key.font : UIFont(name: textFontName, size: labelFontSize)!
        ] as [NSAttributedString.Key : Any]
    } else {
      wordTextAttributes = [
        NSAttributedString.Key.strokeColor : regularText,
        NSAttributedString.Key.foregroundColor : regularText,
        NSAttributedString.Key.strokeWidth : -1,
        NSAttributedString.Key.font : UIFont(name: textFontName, size: labelFontSize)!
        ] as [NSAttributedString.Key : Any]
    }
    
    WordTextLabel = UILabel(frame: bounds)
    let NSwordText = NSMutableAttributedString(string:  wordText, attributes: wordTextAttributes)
    WordTextLabel.attributedText = NSwordText
    
    WordTextLabel.layer.position.y = fontYOffset
    WordTextLabel.layer.position.x = layer.position.x + width * 0.05
    addSubview(WordTextLabel)
    
    PointsLabel = UILabel(frame: bounds)
    let NSLabelText = NSMutableAttributedString(string: String(w.getPoints()), attributes: wordTextAttributes)
    PointsLabel.attributedText = NSLabelText
    let pointsLabelWidth = NSLabelText.boundingRect(with: CGSize(width: gw, height: frame.height), options: .usesLineFragmentOrigin, context: nil).width
    
    PointsLabel.layer.position.y = fontYOffset
    PointsLabel.layer.position.x = layer.position.x + (width - (pointsLabelWidth + width * 0.10))
    addSubview(PointsLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
