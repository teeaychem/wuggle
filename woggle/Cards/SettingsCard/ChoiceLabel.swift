//
//  ChoiceLabel.swift
//  woggle
//
//  Created by sparkes on 2023/07/05.
//

import UIKit

class ChoiceLabel: UILabel {
  
  unowned var delegate: OptionViewDelegate
  
  let displayText: String
  let internalValue: Int
  
  
  init(frame f: CGRect, displayText dT: String, internalValue iV: Int, delegate d: OptionViewDelegate) {
    
    delegate = d
    
    displayText = dT
    internalValue = iV
    
    super.init(frame: f)
    
    layer.borderColor = UIColor.clear.cgColor
      
    attributedText = NSMutableAttributedString(string: dT, attributes: delegate.getViewData().settingsTextAttributePlain)
  }
  
  
  func select() {
    attributedText = NSMutableAttributedString(string: displayText, attributes: delegate.getViewData().settingsTextAttributeHighlighted)
  }
  
  
  func deselect() {
    attributedText = NSMutableAttributedString(string: displayText, attributes: delegate.getViewData().settingsTextAttributePlain)
  }
  
  
  func addGestures() {
    isUserInteractionEnabled = true
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapChoiceLabel)))
  }
  
  
  func removeGestures() {
    if (gestureRecognizers != nil) {
      for gesture in gestureRecognizers! {
        removeGestureRecognizer(gesture)
      }
      isUserInteractionEnabled = false
    }
  }
  
  
  @objc func didTapChoiceLabel(_ sender: UITapGestureRecognizer) {
    delegate.choiceChangedTo(internalValue: internalValue)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
