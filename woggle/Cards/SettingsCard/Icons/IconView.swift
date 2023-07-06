//
//  IconView.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//


// Class for icon views. This is mostly here for the updateIcon function, to ensure size is constant, and to get some constants to match.


import UIKit

class IconView : UIView {

  let size: CGFloat
  let indent: CGFloat
  let radius: CGFloat
  
  init(size s: CGFloat) {
    
    size = s
    indent = size * 0.1
    radius = size * 0.1
    
    super.init(frame: CGRect(x: 0, y: 0, width: s, height: s))
  }
  
  func updateIcon(value v: String) {
    fatalError("updateIcon must be overriden")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
