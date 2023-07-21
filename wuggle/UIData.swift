//
//  CardUIData.swift
//  wuggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit
import CoreData


class UIData {
  
  var impact: Bool
  var leftSide: Bool
  var showPercent: Bool
  var fadeTiles: Bool

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
  
  let tileFadeOpacity = Float(0.25)
  
  
  init(width w: CGFloat) {

    colourOption = 0
    impact = true
    leftSide = false
    showPercent = true
    //TODO: Link to option on card XXX
    fadeTiles = true
    
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
    // Some of these look very bad to me. That's the point.
    colourOption = profile
    
    switch profile {
    case 1:
      colourD = UIColor(red: 150/255, green: 126/255, blue: 118/255, alpha: 1)
      colourM =  UIColor(red: 215/255, green: 192/255, blue: 174/255, alpha: 1)
      colourL = UIColor(red: 238/255, green: 227/255, blue: 203/255, alpha: 1)
      userInteractionColour = UIColor(red: 255/255, green: 248/255, blue: 235/255, alpha: 1)
      iconBorderColour = UIColor(red: 89/255, green: 19/255, blue: 23/255, alpha: 1)
    case 2:
      colourD = UIColor(red: 44/255, green: 33/255, blue: 41/255, alpha: 1)
      colourM =  UIColor(red: 68/255, green: 57/255, blue: 65/255, alpha: 1)
      colourL = UIColor(red: 91/255, green: 82/255, blue: 88/255, alpha: 1)
      userInteractionColour = UIColor(red: 115/255, green: 107/255, blue: 112/255, alpha: 1)
      iconBorderColour = UIColor(red: 21/255, green: 8/255, blue: 17/255, alpha: 1)
    case 3:
      colourD = UIColor(red: 255/255, green: 246/255, blue: 235/255, alpha: 1)
      colourM =  UIColor(red: 254/255, green: 96/255, blue: 91/255, alpha: 1)
      colourL = UIColor(red: 46/255, green: 95/255, blue: 179/255, alpha: 1)
      userInteractionColour = UIColor(red: 52/255, green: 53/255, blue: 71/255, alpha: 1)
    case 4:
      colourD = UIColor(red: 141/255, green: 123/255, blue: 104/255, alpha: 1)
      colourM =  UIColor(red: 164/255, green: 144/255, blue: 124/255, alpha: 1)
      colourL = UIColor(red: 200/255, green: 182/255, blue: 166/255, alpha: 1)
      userInteractionColour = UIColor(red: 241/255, green: 222/255, blue: 201/255, alpha: 1)
      iconBorderColour = UIColor.black
    case 5:
      colourD = UIColor(red: 55/255, green: 66/255, blue: 89/255, alpha: 1)
      colourM =  UIColor(red: 92/255, green: 137/255, blue: 132/255, alpha: 1)
      colourL = UIColor(red: 186/255, green: 144/255, blue: 166/255, alpha: 1)
      userInteractionColour = UIColor(red: 223/255, green: 246/255, blue: 255/255, alpha: 1)
      iconBorderColour = UIColor(red: 21/255, green: 8/255, blue: 17/255, alpha: 1)
    default:
      colourD =  UIColor.darkGray
      colourM =   UIColor.gray
      colourL =  UIColor.lightGray
      userInteractionColour =  UIColor.white
      iconBorderColour = UIColor.black
    }
  }
  
  
  func loadFromCore() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let UISettingsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UISettings")
    
    do {
      let result = try context.fetch(UISettingsFetchRequest)
      
      if result.count > 0 {
        let savedUIData = result.first as! UISettings
        updateColour(profile: savedUIData.colour)
        impact = savedUIData.impact
        leftSide = savedUIData.leftSide
        showPercent = savedUIData.showPercent
      }
    } catch {
      // If there's an issue loading, don't do anything.
      // Nothing important depends on having these present.
      return
    }
  }
  
  
  func saveToCore() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let UISettingsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UISettings")
    do {
      let result = try context.fetch(UISettingsFetchRequest)
      
      if result.count > 0 {
        let savedUIData = result.first as! UISettings
        savedUIData.colour = colourOption
        savedUIData.impact = impact
        savedUIData.leftSide = leftSide
        savedUIData.showPercent = showPercent
        
      } else {
        let newSave = UISettings(context: context)
        newSave.colour = colourOption
        newSave.impact = impact
        newSave.leftSide = leftSide
        newSave.showPercent = showPercent
      }
      
      do {
        try context.save()
      } catch {
        return
      }
    } catch {
      // If there's an issue loading, don't do anything.
      // Nothing important depends on having these present.
      return
    }
  }
}
