//
//  CardStackViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/23.
//
// The app displays everything as a stack of cards.
// This class controls the display of the cards.

import UIKit
import CoreData

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
    
    width = min(((UIScreen.main.bounds.size.height) / 1.4 / 1.16 ) * 0.9, UIScreen.main.bounds.size.width)
    cardIndent = (UIScreen.main.bounds.size.width - width)/2
    
    let CardVD = ViewData(name: "sett", width: width, colour: UIColor.lightGray.cgColor)
    
    firstCardY = (UIScreen.main.bounds.height - (CardVD.height + CardVD.statusBarSize.height * 2)) * 0.5
    statusBarH = CardVD.statusBarSize.height
    
    super.init(nibName: nil, bundle: nil)

    settCardC = SettingsCardViewController(viewData: CardVD, delegate: self)
    statCardC = StatsCardViewController(viewData: CardVD, delegate: self)
    gameCardC = GameCardViewController(viewData: CardVD, delegate: self)
    
    statCardC?.cardView.backgroundColor = CardVD.colourD
    settCardC?.cardView.backgroundColor = CardVD.colourL
    gameCardC?.cardView.backgroundColor = CardVD.colourM
    
    cardViews = [statCardC!, settCardC!, gameCardC!]

    self.embed(statCardC!, inView: self.view, origin: CGPoint(x: 0, y: firstCardY))
    self.embed(settCardC!, inView: self.view, origin: CGPoint(x: 0, y: firstCardY + CardVD.statusBarSize.height))
    self.embed(gameCardC!, inView: self.view, origin: CGPoint(x: 0, y: firstCardY + CardVD.statusBarSize.height * 2))
    gameCardC?.broughtToTop()
    
    for cV in cardViews {
      cV.addGestureToStatusBar(gesture: UITapGestureRecognizer(target: self, action: #selector(statusBarTap)))
    }
    setIcons()
  }
  
  
  func setIcons() {
    settCardC?.updateIcon(internalName: "time", internalValue: settings.time)
    settCardC?.updateIcon(internalName: "lexicon", internalValue: settings.lexicon)
    settCardC?.updateIcon(internalName: "length", internalValue: settings.minWordLength)
    settCardC?.updateIcon(internalName: "tiles", internalValue: settings.tileSqrt)
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
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}



extension CardStackViewController: CardStackDelegate {
  
  
  func updateSetting(internalName: String, internalValue: Int16) {
    print("Ah, to change")
    // TODO: Need to load or change a setting.
    
    print("Current settings:")
    print(settings)
    
    // First, get the values of the current settings.
    // Use these to perform a search.
    var lexiconVal = settings.lexicon
    var minWordVal = settings.minWordLength
    var tileSqrtVal = settings.tileSqrt
    var timeVal = settings.time
    
    // Update the relevant predicate
    switch internalName {
    case "time":
      print("O: ", timeVal)
      timeVal = internalValue
      print("N: ", timeVal)
    case "lexicon":
      print("O: ", lexiconVal)
      print(type(of: lexiconVal))
      lexiconVal = internalValue
      print("N: ", lexiconVal)
      print(type(of: lexiconVal))
    case "length":
      minWordVal = internalValue
    case "tiles":
      tileSqrtVal = internalValue
    default:
      return
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let settingsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
    settingsFetchRequest.predicate = NSPredicate(
      format: "time == %i AND lexicon == %i AND minWordLength == %i AND tileSqrt == %i",
      timeVal, lexiconVal, minWordVal, tileSqrtVal)
    do {
      let result = try context.fetch(settingsFetchRequest)
      
      if result.count == 1 {
        print("One found")
      } else if result.count > 1 {
        print(result.count)
        print("Extra settings found")
        // TODO: Delete other instances.
      } else {
        print("Search okay, no setting found")
      }
    } catch {
      print("Search failed")
    }
  }
  
  
  func processUpdate() {
    print("Asked to process update")
    statCardC!.respondToUpdate()
  }
  
  
  func currentSettings() -> Settings {
    return settings
  }
  
  
  func currentGame() -> GameInstance? {
    return settings.currentGame
  }
  
  
  func currentStats() -> StatsCollection {
    return settings.stats!
  }
}
