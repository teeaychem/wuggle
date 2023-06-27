//
//  CardStackProtocol.swift
//  woggle
//
//  Created by sparkes on 2023/06/27.
//

import Foundation

protocol CardStackDelegate: AnyObject {
  func processUpdate()
  func provideCurrentSettings() -> Settings
}
