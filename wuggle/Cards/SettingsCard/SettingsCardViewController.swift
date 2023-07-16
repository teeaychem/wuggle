//
//  SettingsCardViewController.swift
//  wuggle
//
//  Created by sparkes on 2023/07/04.
//

import UIKit

class SettingsCardViewController: CardViewController {
   
  private let lengthIcon: IconView
  private let lexiconIcon: IconView
  private let tileIcon: IconView
  private let timeIcon: IconView

  private var optionViews = [String: OptionView]()
  
  override init(iName iN: String, uiData uiD: UIData, delegate d: CardStackDelegate) {
    
    let iconSize = uiD.squareIconSize
    
    lengthIcon = LengthIcon(uiData: uiD)
    lexiconIcon = LexiconIcon(uiData: uiD)
    tileIcon = TileIcon(uiData: uiD)
    timeIcon = TimeIcon(uiData: uiD)
    
    super.init(iName: iN, uiData: uiD, delegate: d)
    
    let iconPadding = (uiD.cardSize.width - (uiD.squareIconSize.width * 4)) * 0.2
    
    // Set up the icons
    statusBarView.addSubview(timeIcon)
    timeIcon.frame.origin.x = iconPadding
    statusBarView.addSubview(lexiconIcon)
    lexiconIcon.frame.origin.x = (iconPadding * 2) + iconSize.width
    statusBarView.addSubview(lengthIcon)
    lengthIcon.frame.origin.x = (iconPadding * 3) + (iconSize.width * 2)
    statusBarView.addSubview(tileIcon)
    tileIcon.frame.origin.x = (iconPadding * 4) + (iconSize.width * 3)
    
    let flatStatSize = CGSize(width: uiData.cardSize.width - uiData.gameBoardPadding * 2, height: uiData.statusBarSize.height)
    
    optionViews["time"] = OptionView(
      frame: CGRect(origin: CGPoint(x: uiData.gameBoardPadding, y: uiData.statusBarSize.height * 1.25), size: flatStatSize),
      optionBlob: delegate!.currentSettings().timeOptionBlob(),
      vertical: false,
      delegate: self
    )
    optionViews["lexicon"] = OptionView(
      frame: CGRect(origin: CGPoint(x: uiData.gameBoardPadding, y: optionViews["time"]!.layer.frame.maxY), size: flatStatSize),
      optionBlob: delegate!.currentSettings().lexiconOptionBlob(),
      vertical: true,
      delegate: self
    )
    optionViews["length"] = OptionView(
      frame: CGRect(origin: CGPoint(x: uiData.gameBoardPadding, y: optionViews["lexicon"]!.layer.frame.maxY), size: flatStatSize),
      optionBlob: delegate!.currentSettings().lengthOptionBlob(),
      vertical: false,
      delegate: self
    )
    optionViews["tiles"] = OptionView(
      frame: CGRect(origin: CGPoint(x: uiData.gameBoardPadding, y: optionViews["length"]!.layer.frame.maxY), size: flatStatSize),
      optionBlob: delegate!.currentSettings().tilesOptionBlob(),
      vertical: false,
      delegate: self
    )
    
    
    // Now reverse order from bottom
    optionViews["colour"] = OptionView(
      frame: CGRect(origin: CGPoint(x: uiData.gameBoardPadding, y: uiData.cardSize.height * 0.98 - flatStatSize.height), size: flatStatSize),
      optionBlob: delegate!.currentSettings().colourOptionBlob(),
      vertical: false,
      delegate: self
    )
    optionViews["side"] = OptionView(
      frame: CGRect(origin: CGPoint(x: uiData.gameBoardPadding, y: optionViews["colour"]!.layer.frame.minY - flatStatSize.height), size: flatStatSize),
      optionBlob: delegate!.currentSettings().sideOptionBlob(),
      vertical: false,
      delegate: self
    )
    optionViews["impact"] = OptionView(
      frame: CGRect(origin: CGPoint(x: uiData.gameBoardPadding, y: optionViews["side"]!.layer.frame.minY - flatStatSize.height), size: flatStatSize),
      optionBlob: delegate!.currentSettings().impactOptionBlob(),
      vertical: false,
      delegate: self
    )
    optionViews["pfound"] = OptionView(
      frame: CGRect(origin: CGPoint(x: uiData.gameBoardPadding, y: optionViews["impact"]!.layer.frame.minY - flatStatSize.height), size: flatStatSize),
      optionBlob: delegate!.currentSettings().pFoundOptionBlob(),
      vertical: false,
      delegate: self
    )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
    
  override func broughtToTop() {
    super.broughtToTop()
    
    for optionView in optionViews.values {
      view.addSubview(optionView)
      optionView.addAndEnableChoiceLabels()
      let sep = UIView(frame: CGRect(x: uiData.gameBoardPadding, y: optionView.frame.maxY, width: uiData.cardSize.width - uiData.gameBoardPadding * 2, height: uiData.cardSize.height * 0.005))
      sep.layer.backgroundColor = uiData.colourD.cgColor
      view.addSubview(sep)
    }

    optionViews["time"]?.highlightChoice(internalOption: delegate!.currentSettings().time)
    optionViews["lexicon"]?.highlightChoice(internalOption: delegate!.currentSettings().lexicon)
    optionViews["length"]?.highlightChoice(internalOption: delegate!.currentSettings().minWordLength)
    optionViews["tiles"]?.highlightChoice(internalOption: delegate!.currentSettings().tileSqrt)
    
    optionViews["pfound"]?.highlightChoice(internalOption: uiData.showPercent ? 1 : 0)
    optionViews["side"]?.highlightChoice(internalOption: uiData.leftSide ? 1 : 0)
    optionViews["impact"]?.highlightChoice(internalOption: uiData.impact ? 1 : 0)
    optionViews["colour"]?.highlightChoice(internalOption: uiData.colourOption)
  }
  
  
  override func shuffledToDeck() {
    super.shuffledToDeck()
    for optionView in optionViews.values {
      optionView.removeFromSuperview()
    }
  }
  
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


extension SettingsCardViewController: SettingsCardViewControllerDelegate {
  
  func updateSetting(internalName: String, internalValue: Int16) {
    
    if internalName.first == "t" || internalName.first == "l" {
      // time, tiles, lexicon, length. Other settings don't start with t/l and don't have icon.
      updateIcon(internalName: internalName, internalValue: internalValue)
    }

    delegate!.updateGeneralSettings(internalName: internalName, internalValue: internalValue)
    // Update the card delegate, which will then update the stored settings and other cards.
    // Update the settings on the card?
    delegate!.processUpdate()
  }
  
  
  func updateIcon(internalName: String, internalValue: Int16) {
    switch internalName {
    case "time":
      timeIcon.updateIcon(value: internalValue)
    case "lexicon":
      lexiconIcon.updateIcon(value: internalValue)
    case "length":
      lengthIcon.updateIcon(value: internalValue)
    case "tiles":
      tileIcon.updateIcon(value: internalValue)
    default:
      return
    }
  }
  
  
  func getUIData() -> UIData {
    return uiData
  }
}
