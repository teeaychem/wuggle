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
  private let firstCardY: CGFloat
  private let statusBarH: CGFloat
  
  var settCardC: SettingsCardViewController?
  var statCardC: StatsCardViewController?
  var gameCardC: GameCardViewController?
  
  private var cardViews: [CardViewController] = []
  private var cardOrigin: CGFloat = 0.0
  
  // TODO: Think about whether to accept settings as an argument, or load/create with this controller.
  unowned var settings: Settings
  
  init(settings s: Settings) {
    
    
    
    settings = s
    
    width = min(((UIScreen.main.bounds.size.height)/1.4/1.16)*0.9, UIScreen.main.bounds.size.width)
    cardIndent = (UIScreen.main.bounds.size.width - width)/2
    
    let settCardVD = CardViewData(name: "sett", width: width, colour: UIColor.lightGray.cgColor)
    let statCardVD = CardViewData(name: "sett", width: width, colour: UIColor.darkGray.cgColor)
    let gameCardVD = CardViewData(name: "game", width: width, colour: UIColor.gray.cgColor)
    
    firstCardY = (UIScreen.main.bounds.height - (gameCardVD.height + gameCardVD.statusBarSize.height * 2)) * 0.5
    statusBarH = gameCardVD.statusBarSize.height

    
    super.init(nibName: nil, bundle: nil)

    settCardC = SettingsCardViewController(viewData: settCardVD, delegate: self)
    statCardC = StatsCardViewController(viewData: statCardVD, delegate: self)
    gameCardC = GameCardViewController(viewData: gameCardVD, delegate: self)
    
    cardViews = [statCardC!, settCardC!, gameCardC!]


    self.embed(statCardC!, inView: self.view, frame: CGRect(origin: CGPoint(x: 0, y: firstCardY), size: statCardVD.cardSize))
    self.embed(settCardC!, inView: self.view, frame: CGRect(origin: CGPoint(x: 0, y: firstCardY + gameCardVD.statusBarSize.height), size: settCardVD.cardSize))
    self.embed(gameCardC!, inView: self.view, frame: CGRect(origin: CGPoint(x: 0, y: firstCardY + gameCardVD.statusBarSize.height * 2), size: gameCardVD.cardSize))
    
    for cV in cardViews {
      cV.addGestureToStatusBar(gesture: UITapGestureRecognizer(target: self, action: #selector(statusBarTap)))
    }
    
    setIcons()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setIcons() {
    settCardC?.updateIcon(internalName: "time", internalValue: settings.time)
    settCardC?.updateIcon(internalName: "lexicon", internalValue: settings.lexicon)
    settCardC?.updateIcon(internalName: "length", internalValue: settings.minWordLength)
    settCardC?.updateIcon(internalName: "tiles", internalValue: settings.tileSqrt)
  }
}

extension CardStackViewController: CardStackDelegate {
  
  
  func updateSetting(internalName: String, internalValue: Int16) {
    switch internalName {
    case "time":
      settings.time = internalValue
    case "lexicon":
      settings.lexicon = internalValue
    case "length":
      settings.minWordLength = internalValue
    case "tiles":
      settings.tileSqrt = internalValue
    default:
      return
    }
  }
  
  
  func processUpdate() {
    print("Asked to process update")
  }
  
  func currentSettings() -> Settings {
    return settings
  }
  
  func currentGameInstance() -> GameInstance? {
    return settings.currentGame
  }
  
  
  func reorderCardsByList() {
    for i in 0...cardViews.count - 1 {
      view.bringSubviewToFront(cardViews[i].view)
      cardViews[i].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(i) * statusBarH))
    }
  }
  
  
  @objc func statusBarTap(_ r: UIGestureRecognizer) {
    let cardIndex = cardViews.firstIndex(where: {r.view?.superview as! CardView == $0.cardView})
    if (cardIndex != nil && cardIndex != cardViews.count - 1) {
      cardViews.last!.shuffledToDeck()
      cardViews.append(cardViews[cardIndex!])
      cardViews.remove(at: cardIndex!)
      reorderCardsByList()
      cardViews.last!.broughtToTop()
    }
  }
  
  
  
}
