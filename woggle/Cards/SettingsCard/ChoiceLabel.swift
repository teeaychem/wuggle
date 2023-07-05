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
  let internalValue: Int16
  
  
  init(frame f: CGRect, displayText dT: String, internalValue iV: Int16, delegate d: OptionViewDelegate) {
    
    delegate = d
    
    displayText = dT
    internalValue = iV
    
    super.init(frame: f)
    
    layer.borderColor = UIColor.clear.cgColor
      
    attributedText = NSMutableAttributedString(string: dT, attributes: delegate.getViewData().getSettingsTextAttributePlain(height: f.height * 0.8))
  }
  
  
  func select() {
    attributedText = NSMutableAttributedString(string: displayText, attributes: delegate.getViewData().getSettingsTextAttributeHighlighted(height: frame.height * 0.8))
  }
  
  
  func deselect() {
    attributedText = NSMutableAttributedString(string: displayText, attributes: delegate.getViewData().getSettingsTextAttributePlain(height: frame.height * 0.8))
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
