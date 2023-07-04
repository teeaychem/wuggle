//
//  CardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit

class CardViewController: UIViewController {
  
  weak var delegate: CardStackDelegate?
  
  let viewData: CardViewData
  let card: CardView
  
  // displayViews collects the views which should only be shown when the card is displayed.
  var displayViews = [UIView]()
  
  
  init(viewData vD: CardViewData, delegate d: CardStackDelegate) {
    viewData = vD
    card = CardView(cardWidth: viewData.width, cardColour: viewData.colour)
    delegate = d
    
    super.init(nibName: nil, bundle: nil)
    view.frame.size.width = vD.width
    view.frame.size.height = vD.height
    
    specificSetup()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // So, subviews need to be added after viewDidLoad.
    // If this doesn't happen, then gestures are broken.
    view.addSubview(card)
  }
  
  
  func specificSetup() {
    // Called by default, and specific in subclasses by overriding.
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
