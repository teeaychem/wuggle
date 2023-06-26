//
//  WordExtension.swift
//  woggle
//
//  Created by sparkes on 2023/06/26.
//

import Foundation

extension Word {
  
  func getPoints() -> Int16 {
    guard (self.value != nil) else {return 0}
    
    switch self.value!.count {
    case 3:
      return 1
    case 4:
      return 1
    case 5:
      return 2
    case 6:
      return 3
    case 7:
      return 5
    default:
      return 11
    }
  }
}
