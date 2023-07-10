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
  
  let colourL: UIColor
  let colourM: UIColor
  var colourD: UIColor
  
  let height: CGFloat
  let cardSize: CGSize
  let statusBarSize: CGSize
  let gameBoardSize: CGFloat
  let tilePadding: CGFloat
  let gameBoardPadding: CGFloat
  let squareIconSize: CGSize
  let scoreIconSize: CGSize
  
  let stopWatchSize: CGFloat
  let playPauseStopSize: CGSize
  let foundWordViewWidth: CGFloat
  
  
  init(name n: String, width w: CGFloat, colour c: CGColor) {
    name = n
    width = w
    colour = c
    
    colourL = UIColor.red // UIColor.lightGray
    colourM = UIColor.orange // UIColor.gray
    colourD = UIColor.purple //  UIColor.darkGray
    
    height = width * 1.4

    cardSize = CGSize(width: width, height: height)
    statusBarSize = CGSize(width: width, height: height * 0.07)
    gameBoardSize = width * 0.95
    tilePadding = gameBoardSize * 0.01
    gameBoardPadding = (width - gameBoardSize) * 0.5
    squareIconSize = CGSize(width: statusBarSize.height, height: statusBarSize.height)
    scoreIconSize = CGSize(width: statusBarSize.height * 3, height: statusBarSize.height)
    
    stopWatchSize = height - (3 * gameBoardPadding + gameBoardSize + statusBarSize.height)
    playPauseStopSize = CGSize(width: stopWatchSize * 0.5, height: stopWatchSize)
    foundWordViewWidth = width - ((4 * gameBoardPadding) + (1.5 * stopWatchSize))
  }
  
 func getSettingsTextAttributePlain(height: CGFloat) -> [NSAttributedString.Key : Any] {
    return [
      NSAttributedString.Key.strokeColor : UIColor.black,
      NSAttributedString.Key.strokeWidth : 0,
      NSAttributedString.Key.foregroundColor : colourM,
      NSAttributedString.Key.font : UIFont(name: uiFontName, size: getFontFor(height: height))!
      ] as [NSAttributedString.Key : Any]
  }
  
  
  func getSettingsTextAttributeHighlighted(height: CGFloat) -> [NSAttributedString.Key : Any] {
    return [
      NSAttributedString.Key.strokeColor : UIColor.black,
      NSAttributedString.Key.strokeWidth : 0,
      NSAttributedString.Key.foregroundColor : colourD,
      NSAttributedString.Key.font : UIFont(name: uiFontName, size: getFontFor(height: height))!
      ] as [NSAttributedString.Key : Any]
  }
}
