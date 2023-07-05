//
//  SettingsCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/04.
//

import UIKit

class SettingsCardViewController: CardViewController {
   
  let lengthIcon: IconView
  let lexiconIcon: IconView
  let tileIcon: IconView
  let timeIcon: IconView
  
  var optionViews = [String: OptionView]()
  var tempViews = [UIView]()
  
  override init(viewData vD: CardViewData, delegate d: CardStackDelegate) {
    
    let iconSize = vD.statusBarHeight
    
    lengthIcon = LengthIcon(size: iconSize)
    lexiconIcon = LexiconIcon(size: iconSize)
    tileIcon = TileIcon(size: iconSize)
    timeIcon = TimeIcon(size: iconSize)
    
    super.init(viewData: vD, delegate: d)
    
    let iconPadding = (vD.width - (vD.statusBarHeight * 4)) * 0.2
    
    // Set up the icons
    statusBarView.addSubview(timeIcon)
    timeIcon.frame.origin.x = iconPadding
    statusBarView.addSubview(lexiconIcon)
    lexiconIcon.frame.origin.x = (iconPadding * 2) + iconSize
    statusBarView.addSubview(lengthIcon)
    lengthIcon.frame.origin.x = (iconPadding * 3) + (iconSize * 2)
    statusBarView.addSubview(tileIcon)
    tileIcon.frame.origin.x = (iconPadding * 4) + (iconSize * 3)
          
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
    
  override func broughtToTop() {
    super.broughtToTop()
    optionViews["time"] = OptionView(frame: CGRect(x: viewData.gameBoardPadding(), y: viewData.statusBarHeight * 1.25, width: viewData.width - viewData.gameBoardPadding() * 2, height: viewData.statusBarHeight), displayName: "Time", displayOptions: ["1", "2", "3", "5", "7", "∞"], internalName: "time", internalOptions: [1, 2, 3, 5, 7, 0], vertical: false, delegate: self)
    optionViews["dictionary"] = OptionView(frame: CGRect(x: viewData.gameBoardPadding(), y: optionViews["time"]!.layer.frame.maxY, width: viewData.width - viewData.gameBoardPadding() * 2, height: viewData.statusBarHeight), displayName: "Dictionary", displayOptions: ["Lots of words", "Jane Austen", "Virgina Woolf", "King James Bible", "Shakespeare"], internalName: "dictionary", internalOptions: [0, 1, 2, 3, 4], vertical: true, delegate: self)
    optionViews["length"] = OptionView(frame: CGRect(x: viewData.gameBoardPadding(), y: optionViews["dictionary"]!.layer.frame.maxY, width: viewData.width - viewData.gameBoardPadding() * 2, height: viewData.statusBarHeight), displayName: "Word Length", displayOptions: ["3+", "4+", "5+", "6+"], internalName: "length", internalOptions: [3, 4, 5, 6], vertical: false, delegate: self)
    optionViews["tiles"] = OptionView(frame: CGRect(x: viewData.gameBoardPadding(), y: optionViews["length"]!.layer.frame.maxY, width: viewData.width - viewData.gameBoardPadding() * 2, height: viewData.statusBarHeight), displayName: "Tiles", displayOptions: ["4²", "5²", "6²", "7²", "8²"], internalName: "tiles", internalOptions: [4, 5, 6, 7, 8], vertical: false, delegate: self)
    
    for optionView in optionViews.values {
      view.addSubview(optionView)
      optionView.addAndEnableChoiceLabels()
      let sep = UIView(frame: CGRect(x: viewData.gameBoardPadding(), y: optionView.frame.maxY, width: viewData.width - viewData.gameBoardPadding() * 2, height: viewData.height * 0.005))
      sep.layer.backgroundColor = UIColor.darkGray.cgColor
      view.addSubview(sep)
    }

    optionViews["time"]?.highlightChoice(internalOption: delegate!.currentSettings().time)
    optionViews["dictionary"]?.highlightChoice(internalOption: delegate!.currentSettings().lexicon)
    optionViews["length"]?.highlightChoice(internalOption: delegate!.currentSettings().minWordLength)
    optionViews["tiles"]?.highlightChoice(internalOption: delegate!.currentSettings().tileSqrt)
  }
  
  
  override func shuffledToDeck() {
    super.shuffledToDeck()
    for optionView in optionViews.values {
      optionView.removeFromSuperview()
    }
    optionViews.removeAll(keepingCapacity: true)
    for tempView in tempViews {
      tempView.removeFromSuperview()
    }
    tempViews.removeAll(keepingCapacity: true)
  }
  
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


extension SettingsCardViewController: SettingsCardViewControllerDelegate {
  
  func updateSetting(internalName: String, internalValue: Int16) {
    // Update the card delegate, which will then update the stored settings and other cards.
    // Update the settings on the card?
    print(internalName)
    print(internalValue)
  }
  
  
  func getViewData() -> CardViewData {
    return viewData
  }
}
