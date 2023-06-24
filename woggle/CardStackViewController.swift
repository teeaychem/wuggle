//
//  CardStackViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/23.
//

import UIKit

class CardStackViewController: UIViewController {
  
  private let width: CGFloat
  private let cardIndent: CGFloat
  
//  private var cardViews = [CardView]()
  private var cardOrigin: CGFloat = 0.0
  
  init() {
    
    width = min(((UIScreen.main.bounds.size.height)/1.4/1.16)*0.9, UIScreen.main.bounds.size.width)
    cardIndent = (UIScreen.main.bounds.size.width - width)/2
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
  
}
