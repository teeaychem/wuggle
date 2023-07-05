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
  let internalOptions: [Int]
  var choiceLabels = [ChoiceLabel]()
  
  init(frame f: CGRect, viewData: CardViewData, displayName dN: String, displayOptions dO: [String], internalName iN: String, internalOptions iO: [Int], delegate d: SettingsCardViewControllerDelegate) {
    
    delegate = d
    
    displayName = dN
    displayOptions = dO
    internalName = iN
    internalOptions = iO
    
    super.init(frame: f)
    
    backgroundColor = UIColor.clear
    
    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: f.width * 0.2, height: f.height))
    nameLabel.text = dN
    nameLabel.textColor = UIColor.gray
    addSubview(nameLabel)
    
    let choiceLabelSize = (f.width * 0.5) / CGFloat(displayOptions.count)
    
    for i in 0 ..< displayOptions.count {
      let choiceLabel = ChoiceLabel(frame: CGRect(origin: CGPoint(x: (f.width * 0.5) + choiceLabelSize * CGFloat(i), y: 0), size: CGSize(width: choiceLabelSize, height: choiceLabelSize)), displayText: dO[i], internalName: iN, internalValue: iO[i], delegate: d)
      choiceLabels.append(choiceLabel)
    }
  }
  
  
  func addAndEnableChoiceLabels() {
    for label in choiceLabels {
      addSubview(label)
      label.addGestures()
    }
  }
  
  
  
  
  
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
}
