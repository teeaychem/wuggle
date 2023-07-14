//
//  SettingsCardViewController.swift
//  woggle
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
  
  override init(iName iN: String, viewData vD: UIData, delegate d: CardStackDelegate) {
    
    let iconSize = vD.squareIconSize
    
    lengthIcon = LengthIcon(viewData: vD)
    lexiconIcon = LexiconIcon(viewData: vD)
    tileIcon = TileIcon(viewData: vD)
    timeIcon = TimeIcon(viewData: vD)
    
    super.init(iName: iN, viewData: vD, delegate: d)
    
    let iconPadding = (vD.cardSize.width - (vD.squareIconSize.width * 4)) * 0.2
    
    // Set up the icons
    statusBarView.addSubview(timeIcon)
    timeIcon.frame.origin.x = iconPadding
    statusBarView.addSubview(lexiconIcon)
    lexiconIcon.frame.origin.x = (iconPadding * 2) + iconSize.width
    statusBarView.addSubview(lengthIcon)
    lengthIcon.frame.origin.x = (iconPadding * 3) + (iconSize.width * 2)
    statusBarView.addSubview(tileIcon)
    tileIcon.frame.origin.x = (iconPadding * 4) + (iconSize.width * 3)
    
    let flatStatSize = CGSize(width: viewData.cardSize.width - viewData.gameBoardPadding * 2, height: viewData.statusBarSize.height)
    
    optionViews["time"] = OptionView(
      frame: CGRect(origin: CGPoint(x: viewData.gameBoardPadding, y: viewData.statusBarSize.height * 1.25), size: flatStatSize),
      optionBlob: delegate!.currentSettings().timeOptionBlob(),
      vertical: false,
      delegate: self
    )
    optionViews["lexicon"] = OptionView(
      frame: CGRect(origin: CGPoint(x: viewData.gameBoardPadding, y: optionViews["time"]!.layer.frame.maxY), size: flatStatSize),
      optionBlob: delegate!.currentSettings().lexiconOptionBlob(),
      vertical: true,
      delegate: self
    )
    optionViews["length"] = OptionView(
      frame: CGRect(origin: CGPoint(x: viewData.gameBoardPadding, y: optionViews["lexicon"]!.layer.frame.maxY), size: flatStatSize),
      optionBlob: delegate!.currentSettings().lengthOptionBlob(),
      vertical: false,
      delegate: self
    )
    optionViews["tiles"] = OptionView(
      frame: CGRect(origin: CGPoint(x: viewData.gameBoardPadding, y: optionViews["length"]!.layer.frame.maxY), size: flatStatSize),
      optionBlob: delegate!.currentSettings().tilesOptionBlob(),
      vertical: false,
      delegate: self
    )
    optionViews["pfound"] = OptionView(
      frame: CGRect(origin: CGPoint(x: viewData.gameBoardPadding, y: optionViews["tiles"]!.layer.frame.maxY), size: flatStatSize),
      optionBlob: delegate!.currentSettings().pFoundOptionBlob(),
      vertical: false,
      delegate: self
    )
    // TODO: Make impact when on is pressed.
    optionViews["impact"] = OptionView(
      frame: CGRect(origin: CGPoint(x: viewData.gameBoardPadding, y: optionViews["pfound"]!.layer.frame.maxY), size: flatStatSize),
      optionBlob: delegate!.currentSettings().impactOptionBlob(),
      vertical: false,
      delegate: self
    )
    optionViews["side"] = OptionView(
      frame: CGRect(origin: CGPoint(x: viewData.gameBoardPadding, y: optionViews["impact"]!.layer.frame.maxY), size: flatStatSize),
      optionBlob: delegate!.currentSettings().sideOptionBlob(),
      vertical: false,
      delegate: self
    )
    optionViews["colour"] = OptionView(
      frame: CGRect(origin: CGPoint(x: viewData.gameBoardPadding, y: optionViews["side"]!.layer.frame.maxY), size: flatStatSize),
      optionBlob: delegate!.currentSettings().colourOptionBlob(),
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
      let sep = UIView(frame: CGRect(x: viewData.gameBoardPadding, y: optionView.frame.maxY, width: viewData.cardSize.width - viewData.gameBoardPadding * 2, height: viewData.cardSize.height * 0.005))
      sep.layer.backgroundColor = viewData.colourD.cgColor
      view.addSubview(sep)
    }

    optionViews["time"]?.highlightChoice(internalOption: delegate!.currentSettings().time)
    optionViews["lexicon"]?.highlightChoice(internalOption: delegate!.currentSettings().lexicon)
    optionViews["length"]?.highlightChoice(internalOption: delegate!.currentSettings().minWordLength)
    optionViews["tiles"]?.highlightChoice(internalOption: delegate!.currentSettings().tileSqrt)
    
    optionViews["pfound"]?.highlightChoice(internalOption: viewData.showPercent ? 1 : 0)
    optionViews["side"]?.highlightChoice(internalOption: viewData.leftSide ? 1 : 0)
    optionViews["impact"]?.highlightChoice(internalOption: viewData.impact ? 1 : 0)
    optionViews["colour"]?.highlightChoice(internalOption: viewData.colourOption)
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
    
    switch internalName {
    case "time", "lexicon", "length", "tiles":
      updateIcon(internalName: internalName, internalValue: internalValue)
    default:
      print("Default update")
    }
    
    print("asked to update setting")
    delegate!.updateSetting(internalName: internalName, internalValue: internalValue)
    // Update the card delegate, which will then update the stored settings and other cards.
    // Update the settings on the card?
    print("asked to process update")
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
  
  
  func getViewData() -> UIData {
    return viewData
  }
}
