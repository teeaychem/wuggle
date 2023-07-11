//
//  CardViewData.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit


class ViewData {
    
  let name: String
  let width: CGFloat
  var colour: CGColor
  
  let colourL: UIColor
  let colourM: UIColor
  var colourD: UIColor
  
  let textHighlightColour = UIColor.darkGray.cgColor
  
  let height: CGFloat
  let cardSize: CGSize
  let statusBarSize: CGSize
  let gameBoardSize: CGFloat
  let tilePadding: CGFloat
  let gameBoardPadding: CGFloat
  let squareIconSize: CGSize
  let scoreIconSize: CGSize
  let statSize: CGSize
  
  let stopWatchSize: CGFloat
  let playPauseStopSize: CGSize
  let foundWordViewWidth: CGFloat
  
  
  init(name n: String, width w: CGFloat, colour c: CGColor) {
    name = n
    width = w
    colour = c
    
    colourL = UIColor.lightGray
    colourM = UIColor.gray
    colourD = UIColor.darkGray
    
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
    
    statSize = CGSize(width: width * 0.95, height: statusBarSize.height * 1.25)
  }
  
  func getSettingsTextAttribute(height: CGFloat, colour: CGColor) -> [NSAttributedString.Key : Any] {
    return [
      NSAttributedString.Key.strokeColor : UIColor.black,
      NSAttributedString.Key.strokeWidth : 0,
      NSAttributedString.Key.foregroundColor : colour,
      NSAttributedString.Key.font : UIFont(name: uiFontName, size: getFontFor(height: height))!
      ] as [NSAttributedString.Key : Any]
  }
}
