//
//  UITableViewWordCell.swift
//  buggle
//
//  Created by Benjamin Sparkes on 13/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit

class UITableViewWordCell : UITableViewCell {
  
  init(style s : UITableViewCell.CellStyle, reuseIdentifier r: String?, word w: String, width gw: CGFloat, height h: CGFloat, shadeWords sh: Bool) {
    
    super.init(style: s, reuseIdentifier: r)
    
    backgroundColor = UIColor.clear
    
    var wordTextAttributes: [NSAttributedString.Key : Any]
    
//    if sh && w.found {
//      wordTextAttributes = [
//        NSAttributedString.Key.strokeColor : reguardTextShaded,
//        NSAttributedString.Key.foregroundColor : reguardTextShaded,
//        NSAttributedString.Key.strokeWidth : -1,
//        NSAttributedString.Key.font : UIFont(name: textFontName, size: h)!
//        ] as [NSAttributedString.Key : Any]
//    } else {
      wordTextAttributes = [
        NSAttributedString.Key.strokeColor : regularText,
        NSAttributedString.Key.foregroundColor : regularText,
        NSAttributedString.Key.strokeWidth : -1,
        NSAttributedString.Key.font : UIFont(name: textFontName, size: h * 0.8)!
        ] as [NSAttributedString.Key : Any]
//    }
    
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
