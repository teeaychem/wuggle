//
//  ChoiceLabel.swift
//  woggle
//
//  Created by sparkes on 2023/07/05.
//

import UIKit

class ChoiceLabel: UILabel {
  
  unowned var delegate: SettingsCardViewControllerDelegate
  
  let displayText: String
  let internalName: String
  let internalValue: Int
  
  
  init(frame f: CGRect, displayText dT: String, internalName iN: String, internalValue iV: Int, delegate d: SettingsCardViewControllerDelegate) {
    
    delegate = d
    
    displayText = dT
    internalName = iN
    internalValue = iV
    
    super.init(frame: f)
    
    text = dT
    backgroundColor = UIColor.black
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
    print("tap")
    delegate.updateSetting(internalName: internalName, internalValue: internalValue)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
