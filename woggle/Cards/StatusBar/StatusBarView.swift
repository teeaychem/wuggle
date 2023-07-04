//
//  StatusBarView.swift
//  woggle
//
//  Created by sparkes on 2023/07/04.
//

import UIKit

class StatusBarView: UIView {
  
  private var elementsDictionary = [String: String]()
  private var elementsOrder = [String]()
  
  override init(frame f: CGRect) {
    super.init(frame: f)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
