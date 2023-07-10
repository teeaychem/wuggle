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
  var colour: CGColor
  
  let height: CGFloat
  let cardSize: CGSize
  let statusBarHeight: CGFloat
  let gameBoardSize: CGFloat
  let tilePadding: CGFloat
  let gameBoardPadding: CGFloat
  let iconSize: CGSize
  
  let stopWatchSize: CGFloat
  let playPauseStopSize: CGSize
  let foundWordViewWidth: CGFloat
  
  
  init(name n: String, width w: CGFloat, colour c: CGColor) {
    name = n
    width = w
    colour = c
    height = width * 1.4

    cardSize = CGSize(width: width, height: height)
    statusBarHeight = height * 0.07
    gameBoardSize = width * 0.95
    tilePadding = gameBoardSize * 0.01
    gameBoardPadding = (width - gameBoardSize) * 0.5
    iconSize = CGSize(width: statusBarHeight, height: statusBarHeight)  
    
    stopWatchSize = height - (3 * gameBoardPadding + gameBoardSize + statusBarHeight)
    playPauseStopSize = CGSize(width: stopWatchSize * 0.5, height: stopWatchSize)
    foundWordViewWidth = width - ((4 * gameBoardPadding) + (1.5 * stopWatchSize))
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
