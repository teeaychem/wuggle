//
//  ColourProtocol.swift
//  woggle
//
//  Created by sparkes on 2023/07/10.
//

import Foundation


protocol ViewDelegate: AnyObject {
  
  func getUIData() -> UIData
  // Return uiData
  
  
  func paintDirect()
  // Paint everything the card has access to.
  
  func sizes()
}
