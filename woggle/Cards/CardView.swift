//
//  CardView.swift
//  woggle
//
//  Created by sparkes on 2023/06/23.
//

import UIKit

class CardView: UIView {
  
  let cardWidth: CGFloat
  let cardHeight: CGFloat
  var cardColour: CGColor
    
  // displayViews collects the views which should only be shown when the card is displayed.
  var displayViews = [UIView]()
  
  
  init(cardWidth width: CGFloat, cardColour color: CGColor) {
    cardWidth = width
    cardHeight = width*1.4
    cardColour = color
    
    super.init(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
    
    layer.cornerRadius = getCornerRadius(width: cardWidth)
    layer.backgroundColor = cardColour
    layer.borderColor = UIColor.black.cgColor
    layer.borderWidth = 1
    
//    addSubview(statusBar)
  }
  
  required init(coder: NSCoder) {
    fatalError("NSCoding not supported")
  }
}
