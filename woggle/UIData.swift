//
//  CardViewData.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit


class UIData {
  
  var impact: Bool
  var leftSide: Bool
  var showPercent: Bool
    
  let name: String
  var colourOption: Int16

  
  var colourL: UIColor
  var colourM: UIColor
  var colourD: UIColor
  var userInteractionColour: UIColor
  var iconBorderColour: UIColor
  
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
  
  
  init(name n: String, width w: CGFloat, colourOption cO: Int16) {
    name = n
    colourOption = cO
    
    impact = true
    leftSide = true
    showPercent = true
    
    colourD =  UIColor.darkGray
    colourM =   UIColor.gray
    colourL =  UIColor.lightGray
    
    userInteractionColour =  UIColor.white
    iconBorderColour = UIColor.black

    cardSize = CGSize(width: w, height: w * 1.4)
    statusBarSize = CGSize(width: cardSize.width, height: cardSize.height * 0.07)
    gameBoardSize = cardSize.width * 0.95
    tilePadding = gameBoardSize * 0.01
    gameBoardPadding = (cardSize.width - gameBoardSize) * 0.5
    squareIconSize = CGSize(width: statusBarSize.height, height: statusBarSize.height)
    scoreIconSize = CGSize(width: cardSize.width * 0.3, height: statusBarSize.height)
    stopWatchSize = cardSize.height - ((3 * gameBoardPadding) + gameBoardSize + statusBarSize.height)
    playPauseStopSize = CGSize(width: stopWatchSize * 0.5, height: stopWatchSize)
    foundWordViewWidth = cardSize.width - ((4 * gameBoardPadding) + (1.5 * stopWatchSize))
    statSize = CGSize(width: cardSize.width * 0.95, height: statusBarSize.height * 1.25)
  }
  
  func getSettingsTextAttribute(height: CGFloat, colour: CGColor) -> [NSAttributedString.Key : Any] {
    return [
      NSAttributedString.Key.strokeWidth : 0,
      NSAttributedString.Key.foregroundColor : colour,
      NSAttributedString.Key.font : UIFont(name: uiFontName, size: getFontFor(height: height))!
      ] as [NSAttributedString.Key : Any]
  }
  
  
  func updateColour(profile: Int16) {
    
    switch profile {
    case 1:
      colourD = UIColor(red: 150/255, green: 126/255, blue: 118/255, alpha: 1)
      colourM =  UIColor(red: 215/255, green: 192/255, blue: 174/255, alpha: 1)
      colourL = UIColor(red: 238/255, green: 227/255, blue: 203/255, alpha: 1)
      userInteractionColour = UIColor(red: 155/255, green: 171/255, blue: 184/255, alpha: 1)
      iconBorderColour = UIColor.black
    case 2:
      colourD = UIColor(red: 44/255, green: 33/255, blue: 41/255, alpha: 1)
      colourM =  UIColor(red: 68/255, green: 57/255, blue: 65/255, alpha: 1)
      colourL = UIColor(red: 91/255, green: 82/255, blue: 88/255, alpha: 1)
      userInteractionColour = UIColor(red: 115/255, green: 107/255, blue: 112/255, alpha: 1)
      iconBorderColour = UIColor(red: 21/255, green: 8/255, blue: 17/255, alpha: 1)
    case 3:
      colourD = UIColor(red: 35/255, green: 57/255, blue: 93/255, alpha: 1)
      colourM =  UIColor(red: 57/255, green: 77/255, blue: 109/255, alpha: 1)
      colourL = UIColor(red: 79/255, green: 97/255, blue: 125/255, alpha: 1)
      userInteractionColour = UIColor(red: 123/255, green: 136/255, blue: 158/255, alpha: 1)
    case 4:
      colourD = UIColor(red: 141/255, green: 123/255, blue: 104/255, alpha: 1)
      colourM =  UIColor(red: 164/255, green: 144/255, blue: 124/255, alpha: 1)
      colourL = UIColor(red: 200/255, green: 182/255, blue: 166/255, alpha: 1)
      userInteractionColour = UIColor(red: 241/255, green: 222/255, blue: 201/255, alpha: 1)
      iconBorderColour = UIColor.black
    case 5:
      colourD = UIColor(red: 150/255, green: 126/255, blue: 118/255, alpha: 1)
      colourM =  UIColor(red: 215/255, green: 192/255, blue: 174/255, alpha: 1)
      colourL = UIColor(red: 238/255, green: 227/255, blue: 203/255, alpha: 1)
      userInteractionColour = UIColor(red: 155/255, green: 171/255, blue: 184/255, alpha: 1)
      iconBorderColour = UIColor.black
    default:
      colourD =  UIColor.darkGray
      colourM =   UIColor.gray
      colourL =  UIColor.lightGray
      userInteractionColour =  UIColor.white
      iconBorderColour = UIColor.black
    }
    
    
  }
}
