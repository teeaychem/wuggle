//
//  UITableViewWordCell.swift
//  buggle
//
//  Created by Benjamin Sparkes on 13/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit

class UITableViewWordCell : UITableViewCell {
  
  init(style s : UITableViewCell.CellStyle, word w: String, found f: Bool, width gw: CGFloat, height h: CGFloat) {
    
    super.init(style: s, reuseIdentifier: w)
    
    backgroundColor = UIColor.clear
    
    var wordTextAttributes: [NSAttributedString.Key : Any]
    
    if f {
      wordTextAttributes = [
        NSAttributedString.Key.strokeColor : UIColor.darkGray.cgColor,
        NSAttributedString.Key.foregroundColor : UIColor.darkGray.cgColor,
        NSAttributedString.Key.strokeWidth : 0,
        NSAttributedString.Key.font : UIFont(name: uiFontName, size: getFontFor(height: h))!
        ]
    } else {
      
    wordTextAttributes = [
      NSAttributedString.Key.strokeColor : UIColor.darkGray.cgColor,
      NSAttributedString.Key.foregroundColor : UIColor.darkGray.cgColor,
      NSAttributedString.Key.strokeWidth : 0,
      NSAttributedString.Key.font : UIFont(name: textFontName, size: getFontFor(height: h))!
      ]
    }
    
    let WordTextLabel = UILabel(frame: CGRect(origin: CGPoint(x: gw * 0.05, y: 0), size: CGSize(width: gw * 0.8, height: h)))
    let NSwordText = NSMutableAttributedString(string: w.capitalized, attributes: wordTextAttributes)
    WordTextLabel.attributedText = NSwordText
    
    let NSLabelText = NSMutableAttributedString(string: String(getPoints(word: w)), attributes: wordTextAttributes)
    let PointsLabel = UILabel(frame: CGRect(origin: CGPoint(x: gw - (gw * 0.15), y: 0)  , size: CGSize(width: gw * 0.10, height: h)))
    
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
