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
    
  // displayViews collects the views which should only be shown when the card is displayed.
  var displayViews = [UIView]()
  
  
  init(cardWidth width: CGFloat) {
    cardWidth = width
    cardHeight = width * 1.4
    
    super.init(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
    
    layer.cornerRadius = getCornerRadius(width: cardWidth)
  }
  
  required init(coder: NSCoder) {
    fatalError("NSCoding not supported")
  }
}
