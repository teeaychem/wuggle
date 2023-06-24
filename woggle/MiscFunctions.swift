//
//  MiscFunctions.swift
//  moreWaggle
//
//  Created by sparkes on 2023/06/23.
//

import Foundation

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
