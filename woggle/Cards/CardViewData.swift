//
//  CardViewData.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit

class CardViewData {
  
  let name: String
  let width: CGFloat
  let height: CGFloat
  let statusBarHeight: CGFloat
  var colour: CGColor
  
  init(name: String, width: CGFloat, colour: CGColor) {
    self.name = name
    self.width = width
    self.height = width * 1.4
    self.colour = colour
    self.statusBarHeight = height * 0.07
  }
}
