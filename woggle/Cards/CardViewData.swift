//
//  CardViewData.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit


class CardViewData {
  
  var fontByHeightDict = Dictionary<CGFloat, Double>()
  
  let name: String
  let width: CGFloat
  let height: CGFloat
  let cardSize: CGSize
  let statusBarHeight: CGFloat
  var colour: CGColor
  
  let settingsTextAttributePlain = [
    NSAttributedString.Key.strokeColor : UIColor.black,
    NSAttributedString.Key.strokeWidth : 0,
    NSAttributedString.Key.foregroundColor : UIColor.gray,
    NSAttributedString.Key.font : UIFont(name: uiFontName, size: 25)!
    ] as [NSAttributedString.Key : Any]
  let settingsTextAttributeHighlighted = [
    NSAttributedString.Key.strokeColor : UIColor.black,
    NSAttributedString.Key.strokeWidth : 0,
    NSAttributedString.Key.foregroundColor : UIColor.darkGray,
    NSAttributedString.Key.font : UIFont(name: uiFontName, size: 25)!
    ] as [NSAttributedString.Key : Any]
  
  
  init(name: String, width: CGFloat, colour: CGColor) {
    self.name = name
    self.width = width
    self.height = width * 1.4
    self.cardSize = CGSize(width: width, height: height)
    self.colour = colour
    self.statusBarHeight = height * 0.07
  }
  
  
  func gameBoardSize() -> CGFloat {
    return width * 0.95
  }
  
  
  func gameBoardPadding() -> CGFloat {
    return (width - gameBoardSize()) * 0.5
  }
  
  
  func stopWatchSize() -> CGFloat {
    height - ((3 * gameBoardPadding()) + gameBoardSize() + statusBarHeight)
  }
  
  func playPauseStopSize() -> CGSize {
    CGSize(width: stopWatchSize() * 0.5, height: stopWatchSize())
  }
  
  func tilePadding() -> CGFloat {
    gameBoardSize() * 0.01
  }
  
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
      print("Stored")
      return fontByHeightDict[height]!
    } else {
      let tolerance = 1.00
      var fontMax = 200.00
      var fontMin = 2.00
      
      while (fontMax - fontMin) > tolerance {
  //      print("fontMax", fontMax)
  //      print("fontMin", fontMin)
        
        let fontSplit = (fontMax + fontMin) * 0.5
        
        let testAttributes = [
          NSAttributedString.Key.font : UIFont(name: uiFontName, size: fontSplit)!
        ]
        let testString = NSMutableAttributedString(string: "Q", attributes: testAttributes)
        let fontHeight = testString.boundingRect(with: CGSize(width: 100, height: CGFloat.Magnitude.greatestFiniteMagnitude), context: nil).height
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
  
  
  func getSettingsTextAttributePlain(height: CGFloat) -> [NSAttributedString.Key : Any] {
    return [
      NSAttributedString.Key.strokeColor : UIColor.black,
      NSAttributedString.Key.strokeWidth : 0,
      NSAttributedString.Key.foregroundColor : UIColor.gray,
      NSAttributedString.Key.font : UIFont(name: uiFontName, size: getFontFor(height: height))!
      ] as [NSAttributedString.Key : Any]
  }
  
  
  func getSettingsTextAttributeHighlighted(height: CGFloat) -> [NSAttributedString.Key : Any] {
    return [
      NSAttributedString.Key.strokeColor : UIColor.black,
      NSAttributedString.Key.strokeWidth : 0,
      NSAttributedString.Key.foregroundColor : UIColor.darkGray,
      NSAttributedString.Key.font : UIFont(name: uiFontName, size: getFontFor(height: height))!
      ] as [NSAttributedString.Key : Any]
  }
}
