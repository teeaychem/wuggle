//
//  ColourProtocol.swift
//  woggle
//
//  Created by sparkes on 2023/07/10.
//

import Foundation


protocol ViewDelegate: AnyObject {
  
  func viewData() -> CardViewData
  // Return viewData
  
  
  func paintDirect()
  // Paint everything the card has access to.
  
  func sizes()
}
