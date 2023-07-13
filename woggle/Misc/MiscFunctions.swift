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
  // Kind of random. Maybe mees with some more.
  // Idea is length isn't the only thing.
  
  var points = 0
  for char in word {
    switch char {
    case "A", "B", "E", "I", "L", "M", "O", "R", "S", "T", "U", "C", "D", "G", "N":
      points += 1
    case "P", "F", "H":
      points += 2
    case "K", "W", "Y":
      points += 3
    case "V":
      points += 4
    case "J":
      points += 5
    case "!", "X", "Z":
      points += 6
    default:
      points += 0
    }
  }
  return points
  
//  Kind of boring
//  return max(1, word.count - 4)
}


var fontByHeightDict = Dictionary<CGFloat, Double>() //   [CGFloat: Double]()

func getFontFor(height: CGFloat) -> Double {
  // I want to scale the font used so that it matches the size of the display.
  // All of the frames, etc. I use are calculated relative to the size of the screen.
  // I.e. they're some percentage of width/height.
  // And, height is fixed, while width varies.
  // So, the idea is to use either the height of the frame containing text or some given ratio to find an appropriate font size.

  // To do this, binary search.
  // Fix min and max font sizes.
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


func randomPointOnRectangle(width: CGFloat, height: CGFloat) -> CGPoint {
  // To get random point on perimiter of rectangle, treat the perimiter as a straight line split into four different sections.
  // Get random number on the line, and then find out which section it belongs to.
  
  let randomPoint = Double.random(in: 0...(width * 2 + height * 2))
  
  if randomPoint < height {
    return CGPoint(x: 0, y: randomPoint)
  } else if randomPoint < (width + height) {
    return CGPoint(x: randomPoint - height, y: 0)
  } else if randomPoint < (width + 2 * height) {
    return CGPoint(x: width, y: randomPoint - (width + height))
  } else {
    return CGPoint(x: randomPoint - (2 * height + width), y: height)
  }
}


func randomStartUIBeizerPath(width w: CGFloat, height h: CGFloat) -> UIBezierPath {
  // To draw a rectangle from a random starting point, get a random point on the perimiter.
  // Then, find which side it's on, and go to one of the points on that side.
  // Then, loop round all the points and close.

  let corners = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: w), CGPoint(x: h, y: w), CGPoint(x: h, y: 0)]
  let startPoint = randomPointOnRectangle(width: w, height: h)
  
  let path = UIBezierPath()
  path.move(to: startPoint)
  let firstIndex = corners.firstIndex(where: {$0.x == startPoint.x || $0.y == startPoint.y })
  for i in 0...corners.count {
      path.addLine(to: corners[(firstIndex! + i) % corners.count])
  }
  path.close()
  return path
}


func randomStraightPointOnroundedRectangle(width w: CGFloat, height h: CGFloat, cornerRadius: CGFloat) -> CGPoint {
  // To get random point on perimiter of rectangle, treat the perimiter as a straight line split into four different sections.
  // Get random number on the line, and then find out which section it belongs to.
  let adjustWidth = w - (cornerRadius * 2)
  let adjustHeight = h - (cornerRadius * 2)
  
  let randomPoint = Double.random(in: 0...(adjustWidth * 2 + adjustHeight * 2))
  
  if randomPoint < adjustHeight {
    return CGPoint(x: 0, y: cornerRadius + randomPoint)
  } else if randomPoint < (adjustWidth + adjustHeight) {
    return CGPoint(x: cornerRadius + randomPoint - adjustHeight, y: 0)
  } else if randomPoint < (adjustWidth + 2 * adjustHeight) {
    return CGPoint(x: w, y: cornerRadius + randomPoint - (adjustWidth + adjustHeight))
  } else {
    return CGPoint(x: cornerRadius + randomPoint - ((2 * adjustHeight) + adjustWidth), y: h)
  }
}



func randomStartRoundedUIBeizerPath(width w: CGFloat, height h: CGFloat, cornerRadius: CGFloat) -> UIBezierPath {
  // To draw a rectangle from a random starting point, get a random point on the perimiter.
  // Then, find which side it's on, and go to one of the points on that side.
  // Then, loop round all the points and close.
  // 1 indicates line start/end
  // 0 indicates arc origin.

  let corners = [
    (Double.pi, CGPoint(x: cornerRadius, y: cornerRadius)),
    (1, CGPoint(x: cornerRadius, y: 0)),
    (1, CGPoint(x: w - cornerRadius, y: 0)),
    (Double.pi * -0.5, CGPoint(x: w - cornerRadius, y: cornerRadius)),
    (1, CGPoint(x: w, y: cornerRadius)),
    (1, CGPoint(x: w, y: h - cornerRadius)),
    (0, CGPoint(x: w - cornerRadius, y: h - cornerRadius)),
    (1, CGPoint(x: w - cornerRadius, y: h)),
    (1, CGPoint(x: cornerRadius, y: h)),
    (Double.pi * 0.5, CGPoint(x: cornerRadius, y: h - cornerRadius)),
    (1, CGPoint(x: 0, y: h - cornerRadius)),
    (1, CGPoint(x: 0, y: cornerRadius))
  ]
  let startPoint = randomStraightPointOnroundedRectangle(width: w, height: h, cornerRadius: cornerRadius)
  
  let path = UIBezierPath()
  path.move(to: startPoint)
  let firstIndex = corners.firstIndex(where: {$0.1.x == startPoint.x || $0.1.y == startPoint.y })
  for i in 0...corners.count {
    let position = corners[(firstIndex! + i) % corners.count]
    if (position.0 == 1) {
      path.addLine(to: position.1)
    } else {
      path.addArc(withCenter: position.1, radius: cornerRadius, startAngle: position.0, endAngle: position.0 + Double.pi * 0.5, clockwise: true)
    }
  }
  path.close()
  return path
}
