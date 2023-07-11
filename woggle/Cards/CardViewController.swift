//
//  CardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit

class CardViewController: UIViewController {
  
  weak var delegate: CardStackDelegate?
  
  let viewData: ViewData
  let cardView: CardView
  let statusBarView: StatusBarView
  
  // displayViews collects the views which should only be shown when the card is displayed.
  var displayViews = [UIView]()
  
  
  init(viewData vD: ViewData, delegate d: CardStackDelegate) {
    viewData = vD
    cardView = CardView(cardWidth: viewData.width, cardColour: viewData.colour)
    delegate = d
    statusBarView = StatusBarView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: viewData.width, height: viewData.statusBarSize.height)))
    
    super.init(nibName: nil, bundle: nil)
    view.frame.size = vD.cardSize
    
    specificSetup()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // So, subviews need to be added after viewDidLoad.
    // If this doesn't happen, then gestures are broken.
    view.addSubview(cardView)
    cardView.addSubview(statusBarView)
  }
  
  
  func specificSetup() {
    // Called by default, and specific in subclasses by overriding.
  }
  
  
  func broughtToTop() {
    // Called when card is brought to the top of the stack
  }
  
  
  func shuffledToDeck() {
    // Called when card is shffuled into the deck
  }
  
  
  func addGestureToStatusBar(gesture: UIGestureRecognizer) {
    statusBarView.addGestureRecognizer(gesture)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
