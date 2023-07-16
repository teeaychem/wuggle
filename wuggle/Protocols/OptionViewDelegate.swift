//
//  OptionViewDelegate.swift
//  wuggle
//
//  Created by sparkes on 2023/07/05.
//

import Foundation


protocol OptionViewDelegate: AnyObject {
  
  func choiceChangedTo(internalValue: Int16)
  // Called by choice label when choice is selected.
  
  func getUIData() -> UIData
  
}
