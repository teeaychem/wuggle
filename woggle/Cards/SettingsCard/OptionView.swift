//
//  OptionView.swift
//  woggle
//
//  Created by sparkes on 2023/07/04.
//

import UIKit

class OptionView: UIView {
  
  let displayName: String
  let displayOptions: [String]
  
  init(frame f: CGRect, viewData: CardViewData, displayName dN: String, displayOptions dO: [String]) {
    
    displayName = dN
    displayOptions = dO
    
    super.init(frame: f)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
}
