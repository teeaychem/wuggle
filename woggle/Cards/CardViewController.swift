//
//  CardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit

class CardViewController: UIViewController {
  
  weak var delegate: CardStackDelegate?
  
  let iName: String
  
  let viewData: ViewData
  let cardView: CardView
  
  let statusBarView: StatusBarView
  let mainView: UIView
  
  
  init(iName iN: String, viewData vD: ViewData, delegate d: CardStackDelegate) {
    iName = iN
    viewData = vD
    cardView = CardView(iName: iN, cardWidth: viewData.width)
    delegate = d
    statusBarView = StatusBarView(frame:
                                    CGRect(
                                      origin: CGPoint(x: 0, y: 0),
                                      size: CGSize(width: viewData.width, height: viewData.statusBarSize.height)))
    mainView = UIView(frame:
                        CGRect(
                          origin: CGPoint(x: 0, y: vD.statusBarSize.height),
                          size: CGSize(width: vD.cardSize.width, height: vD.cardSize.height - vD.statusBarSize.height)))
    
    super.init(nibName: nil, bundle: nil)
    
    specificSetup()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame.size = cardView.frame.size
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // So, subviews need to be added after viewDidLoad.
    // If this doesn't happen, then gestures are broken.
    view.addSubview(cardView)
    cardView.addSubview(statusBarView)
    cardView.addSubview(mainView)
  }
  
  
  func specificSetup() {
    // Called by default, and specific in subclasses by overriding.
  }
  
  
  func broughtToTop() {
    // Called when card is brought to the top of the stack
  }
  
  
  func shuffledToDeck() {
    // Called when card is shffuled into the deck
    
    // Remove every subview attached to the mainview.
    for subview in mainView.subviews {
      subview.removeFromSuperview()
    }
  }
  
  
  func respondToUpdate() {
    // Called by StackVC when some card has called StackVC for an update.
  }
  
  
  func addGestureToStatusBar(gesture: UIGestureRecognizer) {
    statusBarView.addGestureRecognizer(gesture)
  }
  
  func removeGesturesFromStatusBar() {
    for gr in statusBarView.gestureRecognizers! {
      statusBarView.removeGestureRecognizer(gr)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
