//
//  OptionView.swift
//  woggle
//
//  Created by sparkes on 2023/07/04.
//

import UIKit

class OptionView: UIView {
  
  unowned var delegate: SettingsCardViewControllerDelegate
  
  let displayName: String
  let displayOptions: [String]
  let internalName: String
  let internalOptions: [Int16]
  let vertical: Bool
  var choiceLabels = [Int16: ChoiceLabel]()
  
  init(frame f: CGRect, displayName dN: String, displayOptions dO: [String], internalName iN: String, internalOptions iO: [Int16], vertical v: Bool, delegate d: SettingsCardViewControllerDelegate) {
    
    delegate = d
    
    displayName = dN
    displayOptions = dO
    internalName = iN
    internalOptions = iO
    vertical = v
    
    // Auto stretch frame if vertical is true.
    // Else, frame height is as specificed.
    if vertical {
      super.init(frame: CGRect(x: f.origin.x, y: f.origin.y, width: f.width, height: f.height * CGFloat(displayOptions.count)))
    } else {
      super.init(frame: CGRect(x: f.origin.x, y: f.origin.y, width: f.width, height: f.height))
    }
    
    backgroundColor = UIColor.clear
    
    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: f.width * 0.4, height: f.height))
    
    nameLabel.attributedText = NSMutableAttributedString(string: dN, attributes: delegate.getViewData().settingsTextAttributePlain)
    addSubview(nameLabel)
    
    if vertical {
      let choiceLabelWidth = (f.width * 0.6)
      for i in 0 ..< displayOptions.count {
        let choiceLabel = ChoiceLabel(frame: CGRect(origin: CGPoint(x: (f.width - choiceLabelWidth), y: CGFloat(i) * f.height), size: CGSize(width: choiceLabelWidth, height: f.height)), displayText: dO[i], internalValue: iO[i], delegate: self)
        choiceLabel.textAlignment = .right
        choiceLabels[internalOptions[i]] = choiceLabel
      }
    } else {
      let choiceLabelWidth =  f.height * 1 // (f.width * 0.6) / CGFloat(displayOptions.count)
      for i in 0 ..< displayOptions.count {
        let choiceLabel = ChoiceLabel(frame: CGRect(origin: CGPoint(x: f.width - choiceLabelWidth * CGFloat(displayOptions.count - i), y: 0), size: CGSize(width: choiceLabelWidth, height: f.height)), displayText: dO[i], internalValue: iO[i], delegate: self)
        choiceLabel.textAlignment = .center
        choiceLabels[internalOptions[i]] = choiceLabel
      }
    }
  }
  
  
  func addAndEnableChoiceLabels() {
    for label in choiceLabels.values {
      addSubview(label)
      label.addGestures()
    }
  }
  
  
  func removeChoiceLabels() {
    for label in choiceLabels.values {
      label.removeGestures()
      label.removeFromSuperview()
    }
  }
  
  
  func highlightChoice(internalOption: Int16) {
    choiceLabels[internalOption]?.select()
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
}


extension OptionView: OptionViewDelegate {
  
  func choiceChangedTo(internalValue: Int16) {
    choiceLabels[internalValue]?.select()
    for k in choiceLabels.keys {
      if k != internalValue {
        choiceLabels[k]!.deselect()
      }
      
    }
    delegate.updateSetting(internalName: internalName, internalValue: internalValue)
  }

  
  func getViewData() -> CardViewData {
    return delegate.getViewData()
  }

}
