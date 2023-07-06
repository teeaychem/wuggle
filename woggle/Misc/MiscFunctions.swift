//
//  MiscFunctions.swift
//  moreWaggle
//
//  Created by sparkes on 2023/06/23.
//

import Foundation
import UIKit

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


var fontByHeightDict = Dictionary<CGFloat, Double>() //   [CGFloat: Double]()

func getFontFor(height: CGFloat) -> Double {
  // I want to scale the font used so that it matches the size of the display.
  // All of the frames, etc. I use are calculated relative to the size of the screen.
  // I.e. they're some percentage of width/height.
  // And, height is fixed, while width varies.
  // So, the idea is to use either the height of the frame containing text or some given ratio to find an appropriate font size.

  // To do this, binary search.
  // I'll fix min and max font sizes.
  // Then, split the difference.
  // Draw text with Q as this *might* drop below the line using the split.
  // If the font fits, I might need bigger. So, split is new min.
  // If font doesn't fix I need smaller, so split is new max.
  // Keep doing this until the difference between min and max is neglibile.
  // Finally, store the result in a dictionary.
  // I'll use the same height a lot, and so will save much effort by storing.
  
  if fontByHeightDict.keys.contains(height) {
    return fontByHeightDict[height]!
  } else {
    let tolerance = 0.5
    var fontMax = 400.00
    var fontMin = 2.00
    
    while (fontMax - fontMin) > tolerance {
      
      let fontSplit = (fontMax + fontMin) * 0.5
      
      let testAttributes = [
        NSAttributedString.Key.font : UIFont(name: uiFontName, size: fontSplit)!
      ]
      let testString = NSMutableAttributedString(string: "Q", attributes: testAttributes)
      let fontHeight = testString.boundingRect(with: CGSize(width: CGFloat.Magnitude.greatestFiniteMagnitude, height: CGFloat.Magnitude.greatestFiniteMagnitude), context: nil).height
      if (fontHeight > height) {
        fontMax = fontSplit
      } else {
        fontMin = fontSplit
      }
    }
    
    fontByHeightDict.updateValue(fontMin, forKey: height)
    // fontMin is guaranteed to fit.
    return fontMin
  }
}
