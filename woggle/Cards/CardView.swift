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
  
//  let statusBar: StatusBarUIView
  
  // displayViews collects the views which should only be shown when the card is displayed.
  var displayViews = [UIView]()
  
  
  init(cardWidth width: CGFloat, cardColour color: CGColor) {
    cardWidth = width
    cardHeight = width*1.4
    cardColour = color
//    statusBar = StatusBarUIView(cardWidth: cardWidth, cardHeight: cardHeight)
    
    super.init(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
    
    layer.cornerRadius = getCornerRadius(width: cardWidth)
    layer.backgroundColor = cardColour
    
//    addSubview(statusBar)
  }

  
  required init(coder: NSCoder) {
    fatalError("NSCoding not supported")
  }
}
