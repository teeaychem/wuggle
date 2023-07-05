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
  
  func getFontFor(height: CGFloat) -> Int {
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
    
    
    
    return 0
  }
}
