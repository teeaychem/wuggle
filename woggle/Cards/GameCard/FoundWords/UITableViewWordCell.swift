//
//  UITableViewWordCell.swift
//  buggle
//
//  Created by Benjamin Sparkes on 13/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit

class UITableViewWordCell : UITableViewCell {
  
  init(viewData vD: ViewData, cellStyle cS : UITableViewCell.CellStyle, word w: String, found f: Bool, size s: CGSize) {
    
    super.init(style: cS, reuseIdentifier: w)
    
    backgroundColor = UIColor.clear
    
    var wordTextAttributes: [NSAttributedString.Key : Any]
    
    if f {
      wordTextAttributes = [
        NSAttributedString.Key.strokeColor : vD.colourD.cgColor,
        NSAttributedString.Key.foregroundColor : vD.colourD.cgColor,
        NSAttributedString.Key.strokeWidth : 0,
        NSAttributedString.Key.font : UIFont(name: uiFontName, size: getFontFor(height: s.height))!
        ]
    } else {
      
    wordTextAttributes = [
      NSAttributedString.Key.strokeColor : vD.colourD.cgColor,
      NSAttributedString.Key.foregroundColor : vD.colourD.cgColor,
      NSAttributedString.Key.strokeWidth : 0,
      NSAttributedString.Key.font : UIFont(name: textFontName, size: getFontFor(height: s.height))!
      ]
    }
    
    let WordTextLabel = UILabel(frame: CGRect(origin: CGPoint(x: s.width * 0.05, y: 0), size: CGSize(width: s.width * 0.8, height: s.height)))
    let NSwordText = NSMutableAttributedString(string: w.capitalized, attributes: wordTextAttributes)
    WordTextLabel.attributedText = NSwordText
    
    let NSLabelText = NSMutableAttributedString(string: String(getPoints(word: w)), attributes: wordTextAttributes)
    let PointsLabel = UILabel(frame: CGRect(origin: CGPoint(x: s.width - (s.width * 0.15), y: 0)  , size: CGSize(width: s.width * 0.10, height: s.height)))
    
    PointsLabel.attributedText = NSLabelText
    // Sees to align nicely.
    PointsLabel.textAlignment = .center
    
    addSubview(WordTextLabel)
    addSubview(PointsLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
