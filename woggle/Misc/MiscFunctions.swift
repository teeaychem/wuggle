//
//  MiscFunctions.swift
//  moreWaggle
//
//  Created by sparkes on 2023/06/23.
//

import Foundation

func getCornerRadius(width w: CGFloat) -> CGFloat {
  return w * (1/30)
}


func distributionSelect(dist: [Double]) -> Int {
  // Assumes distibution is ordered from smallest to largest
  
  // Sum the distribution
  let sum = dist.reduce(0, +)
  // Maginify random percentange by sum
  let choice = sum * (Double(arc4random_uniform(UInt32.max))/Double(UInt32.max))
  // Go through the distribution until we've exceeded the choice by accumilation.
  var accumulated = 0.0
  for (pos, val) in dist.enumerated() {
    accumulated += val
    if choice < accumulated {
      return pos
    }
  }
  return dist.count - 1
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
