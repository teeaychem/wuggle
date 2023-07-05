//
//  OptionViewDelegate.swift
//  woggle
//
//  Created by sparkes on 2023/07/05.
//

import Foundation


protocol OptionViewDelegate: AnyObject {
  
  func choiceChangedTo(internalValue: Int)
  // Called by choice label when choice is selected.
  
  func getViewData() -> CardViewData
  
}
