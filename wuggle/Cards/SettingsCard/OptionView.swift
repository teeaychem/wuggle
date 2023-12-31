//
//  OptionView.swift
//  wuggle
//
//  Created by sparkes on 2023/07/04.
//

import UIKit

class OptionView: UIView {
  
  unowned var delegate: SettingsCardViewControllerDelegate
  
  private let internalName: String
  private var choiceLabels = [Int16: ChoiceLabel]()
  
  init(frame f: CGRect, optionBlob oB: OptionBlob, vertical: Bool, delegate d: SettingsCardViewControllerDelegate) {
    
    delegate = d
    
    internalName = oB.internalName
    
    // Auto stretch frame if vertical is true.
    // Else, frame height is as specificed.
    if vertical {
      super.init(frame: CGRect(x: f.origin.x, y: f.origin.y, width: f.width, height: f.height * CGFloat(oB.displayOptions.count)))
    } else {
      super.init(frame: CGRect(x: f.origin.x, y: f.origin.y, width: f.width, height: f.height))
    }
    
    backgroundColor = UIColor.clear
    
    // Note, f.height for font size as  as frame.height may has been adjusted if vertical.
    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: f.width, height: f.height))
    nameLabel.attributedText = NSMutableAttributedString(string: oB.displayName, attributes: delegate.getUIData().getSettingsTextAttribute(height: f.height * 0.8, colour: delegate.getUIData().colourD.cgColor))
    addSubview(nameLabel)
    
    if vertical {
      let choiceLabelWidth = f.width
      for i in 0 ..< oB.displayOptions.count {
        let choiceLabel = ChoiceLabel(frame: CGRect(origin: CGPoint(x: (f.width - choiceLabelWidth), y: CGFloat(i) * f.height), size: CGSize(width: choiceLabelWidth, height: f.height)), displayText: oB.displayOptions[i], internalValue: oB.internalOptions[i], delegate: self)
        choiceLabel.textAlignment = .right
        choiceLabels[oB.internalOptions[i]] = choiceLabel
      }
    } else {
      let choiceLabelWidth =  f.height
      for i in 0 ..< oB.displayOptions.count {
        let choiceLabel = ChoiceLabel(frame: CGRect(origin: CGPoint(x: f.width - choiceLabelWidth * CGFloat(oB.displayOptions.count - i), y: 0), size: CGSize(width: choiceLabelWidth, height: f.height)), displayText: oB.displayOptions[i], internalValue: oB.internalOptions[i], delegate: self)
        choiceLabel.textAlignment = .center
        choiceLabels[oB.internalOptions[i]] = choiceLabel
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
    choiceLabels[internalOption]?.select(impact: false)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


extension OptionView: OptionViewDelegate {
  
  func choiceChangedTo(internalValue: Int16) {
    for k in choiceLabels.keys {
        choiceLabels[k]!.deselect()
      }
    choiceLabels[internalValue]?.select(impact: true)
    
    delegate.updateSetting(internalName: internalName, internalValue: internalValue)
  }

  
  func getUIData() -> UIData {
    return delegate.getUIData()
  }

}
