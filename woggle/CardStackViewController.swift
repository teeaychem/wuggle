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
  
  
  let CardVD: ViewData
  // Controls the main UI
  
  private let width: CGFloat
  private let cardIndent: CGFloat
  private let firstCardY: CGFloat
  private let statusBarH: CGFloat
  
  private var statsBarTapUIGR: UIGestureRecognizer?
  
  var settCardC: SettingsCardViewController?
  var statCardC: StatsCardViewController?
  var gameCardC: GameCardViewController?
  
  private var cardViews: [CardViewController] = []
  private var cardOrigin: CGFloat = 0.0
  private var topCardIndex: Int
  
  // TODO: Think about whether to accept settings as an argument, or load/create with this controller.
  unowned var settings: Settings
  
  init(settings s: Settings) {
    
    settings = s
    
    width = min(((UIScreen.main.bounds.size.height) / 1.4 / 1.16 ) * 0.9, UIScreen.main.bounds.size.width)
    cardIndent = (UIScreen.main.bounds.size.width - width)/2
    
    CardVD = ViewData(name: "sett", width: width, colourOption: 0)
    
    firstCardY = (UIScreen.main.bounds.height - (CardVD.height + CardVD.statusBarSize.height * 2)) * 0.5
    statusBarH = CardVD.statusBarSize.height
    
    topCardIndex = 2
    
    super.init(nibName: nil, bundle: nil)
    
    statsBarTapUIGR = UITapGestureRecognizer(target: self, action: #selector(statusBarTap))

    makeAndEmbedCards()
    setIcons()
    cardShuffleGesutre(enabled: false)
  }
  
  
  func makeAndEmbedCards() {
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
  }
  
  func deleteCards() {
    for card in cardViews {
      unembed(card, inView: self.view)
    }
    cardViews.removeAll()
  }
  
  
  func setIcons() {
    settCardC?.updateIcon(internalName: "time", internalValue: settings.time)
    settCardC?.updateIcon(internalName: "lexicon", internalValue: settings.lexicon)
    settCardC?.updateIcon(internalName: "length", internalValue: settings.minWordLength)
    settCardC?.updateIcon(internalName: "tiles", internalValue: settings.tileSqrt)
  }
  
  
  func reorderCardsByIndex(index i: Int) {
    // TODO: Adjust this so card order is natural.
    // Then, simplify.
    
    switch i {
    case 0:
      cardViews[1].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(0) * statusBarH))
      cardViews[2].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(1) * statusBarH))
      cardViews[0].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(2) * statusBarH))
      cardViews[1].shuffledToDeck()
      cardViews[2].shuffledToDeck()
      cardViews[0].broughtToTop()
      view.bringSubviewToFront(cardViews[1].view)
      view.bringSubviewToFront(cardViews[2].view)
      view.bringSubviewToFront(cardViews[0].view)
    case 1:
      cardViews[0].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(0) * statusBarH))
      cardViews[2].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(1) * statusBarH))
      cardViews[1].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(2) * statusBarH))
      cardViews[0].shuffledToDeck()
      cardViews[2].shuffledToDeck()
      cardViews[1].broughtToTop()
      view.bringSubviewToFront(cardViews[0].view)
      view.bringSubviewToFront(cardViews[2].view)
      view.bringSubviewToFront(cardViews[1].view)
    case 2:
      cardViews[0].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(0) * statusBarH))
      cardViews[1].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(1) * statusBarH))
      cardViews[2].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(2) * statusBarH))
      cardViews[0].shuffledToDeck()
      cardViews[1].shuffledToDeck()
      cardViews[2].broughtToTop()
      view.bringSubviewToFront(cardViews[0].view)
      view.bringSubviewToFront(cardViews[1].view)
      view.bringSubviewToFront(cardViews[2].view)
    default:
      return
    }
    
    
//    for i in 0...cardViews.count - 1 {
//      view.bringSubviewToFront(cardViews[i].view)
//      cardViews[i].view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(i) * statusBarH))
//    }
  }
  
  
  @objc func statusBarTap(_ r: UIGestureRecognizer) {
    print("tap")
    let cardIndex = cardViews.firstIndex(where: {r.view?.superview as! CardView == $0.cardView})
    print("card index ", cardIndex)
    if (cardIndex != nil && cardIndex != topCardIndex) {
      topCardIndex = cardIndex!
      
//      cardViews.last!.shuffledToDeck()
//      cardViews.append(cardViews[cardIndex!])
//      cardViews.remove(at: cardIndex!)
      reorderCardsByIndex(index: topCardIndex)
//      cardViews.last!.broughtToTop()
    }
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}



extension CardStackViewController: CardStackDelegate {
  
  func cardShuffleGesutre(enabled: Bool) {
    if enabled {
      for cV in cardViews {
        cV.removeGesturesFromStatusBar()
      }
    } else {
      for cV in cardViews {
        cV.addGestureToStatusBar(gesture: UITapGestureRecognizer(target: self, action: #selector(statusBarTap)))
      }
    }
  }
  
  
  func updateSetting(internalName: String, internalValue: Int16) {
    print("Ah, to change")
    // First, get the values of the current settings.
    // There's always *a* settings file, so these are fine to get.
    // Use these to perform a search.
    var lexiconVal = settings.lexicon
    var minWordVal = settings.minWordLength
    var tileSqrtVal = settings.tileSqrt
    var timeVal = settings.time
    
    // Update the relevant predicate
    switch internalName {
    case "time":
      timeVal = internalValue
    case "lexicon":
      lexiconVal = internalValue
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
        settings = result.first as! Settings
      } else if result.count > 1 {
        print(result.count)
        print("Extra settings found")
        // TODO: Delete other instances.
        // 1. Check for stats. Keep stats.
        // 2. Check for most recent date on stats.
      } else {
        // No settings found, so make default
        let freshSettings = Settings(context: context)
        freshSettings.time = timeVal
        freshSettings.lexicon = lexiconVal
        freshSettings.minWordLength = minWordVal
        freshSettings.tileSqrt = tileSqrtVal
        settings = freshSettings
        settings.ensureDefaults()
        print("Search okay, no setting found")
      }
    } catch {
      print("Search failed")
    }
  }
  
  
  func processUpdate() {
    print("Asked to process update")
    statCardC!.respondToUpdate()
    
    // Okay, so whenever somethign is redrawn, I get updated colours.
//    CardVD.colourD = UIColor(red: 150/255, green: 126/255, blue: 118/255, alpha: 1) // UIColor.darkGray
//    CardVD.colourM =  UIColor(red: 215/255, green: 192/255, blue: 174/255, alpha: 1) // UIColor.gray
//    CardVD.colourL = UIColor(red: 238/255, green: 227/255, blue: 203/255, alpha: 1) // UIColor.lightGray
//    
//    CardVD.userInteractionColour = UIColor(red: 155/255, green: 171/255, blue: 184/255, alpha: 1) // UIColor.white
//    CardVD.iconBorderColour = UIColor.black
//    
//    deleteCards()
//    makeAndEmbedCards()
//    cardShuffleGesutre(enabled: false)
//    reorderCardsByIndex(index: topCardIndex)
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
