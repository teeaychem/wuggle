//
//  CardStackViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/23.
//
// The app displays everything as a stack of cards.
// This class controls the display of the cards.

import UIKit

class CardStackViewController: UIViewController {
  // Controls the main UI
  
  private let width: CGFloat
  private let cardIndent: CGFloat
  
  private var cardViews: [CardView] = []
  private var cardOrigin: CGFloat = 0.0
  
  // TODO: Think about whether to accept settings as an argument, or load/create with this controller.
  unowned var settings: Settings
  
  init(settings s: Settings) {
    
    settings = s
    
    width = min(((UIScreen.main.bounds.size.height)/1.4/1.16)*0.9, UIScreen.main.bounds.size.width)
    cardIndent = (UIScreen.main.bounds.size.width - width)/2
    

    
    super.init(nibName: nil, bundle: nil)
    
    let testViewData = CardViewData(name: "test", width: width, colour: UIColor.gray.cgColor)
    let testCardController = GameCardViewController(viewData: testViewData, delegate: self)
    
    self.embed(testCardController, inView: self.view)
    testCardController.view.frame.origin = CGPoint(x: 0, y: 50)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CardStackViewController: CardStackDelegate {
  
  func processUIUpdate() {
    print("Asked to process update")
  }
  
  func provideCurrentSettings() -> Settings {
    return settings
  }
}
