//
//  MiscUIFunctions.swift
//  woggle
//
//  Created by sparkes on 2023/06/23.
//

import UIKit


func getCornerRadius(width w: CGFloat) -> CGFloat {
  return w * (1/30)
}

func getPoints(word: String) -> Int {
  return max(0, word.count - 2)
  
  
//  guard (word == "") else {return 0}
//  
//  switch word.count {
//  case 3:
//    return 1
//  case 4:
//    return 1
//  case 5:
//    return 2
//  case 6:
//    return 3
//  case 7:
//    return 5
//  default:
//    return 11
//  }
}
