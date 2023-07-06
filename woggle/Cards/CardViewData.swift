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
