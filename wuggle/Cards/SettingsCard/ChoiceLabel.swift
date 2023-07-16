//
//  ChoiceLabel.swift
//  wuggle
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
      
    attributedText = NSMutableAttributedString(string: dT, attributes: delegate.getUIData().getSettingsTextAttribute(height: f.height * 0.8, colour: delegate.getUIData().colourM.cgColor))
  }
  
  
  func select(impact: Bool) {
    if (impact && delegate.getUIData().impact) {
      UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.75)
    }
    attributedText = NSMutableAttributedString(string: displayText, attributes: delegate.getUIData().getSettingsTextAttribute(height: frame.height * 0.8, colour: delegate.getUIData().colourD.cgColor))
  }
  
  
  func deselect() {
    attributedText = NSMutableAttributedString(string: displayText, attributes: delegate.getUIData().getSettingsTextAttribute(height: frame.height * 0.8, colour: delegate.getUIData().colourM.cgColor))
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
