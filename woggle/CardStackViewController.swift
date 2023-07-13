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

struct cardViewsStruct {
  
  var settCardC: SettingsCardViewController?
  var statCardC: StatsCardViewController?
  var gameCardC: GameCardViewController?
  
  mutating func deleteCards() {
    settCardC = nil
    statCardC = nil
    gameCardC = nil
  }
  
  func removeGesturesFromStatusBar() {
    settCardC!.removeGesturesFromStatusBar()
    statCardC!.removeGesturesFromStatusBar()
    gameCardC!.removeGesturesFromStatusBar()
  }
}

class CardStackViewController: UIViewController {
  
  
  let uiData: UIData
  // Controls the main UI
  
  private let width: CGFloat
  private let cardIndent: CGFloat
  private let firstCardY: CGFloat
  private let statusBarH: CGFloat
  
  private var statsBarTapUIGR: UIGestureRecognizer?
  
  private var cardViews = cardViewsStruct()
  private var cardOrigin: CGFloat = 0.0
  private var topCardIndex: Int
  
  // TODO: Think about whether to accept settings as an argument, or load/create with this controller.
  unowned var settings: Settings?
  
  init(settings s: Settings) {
    
    settings = s
    
    width = min(((UIScreen.main.bounds.size.height) / 1.4 / 1.16 ) * 0.9, UIScreen.main.bounds.size.width)
    cardIndent = (UIScreen.main.bounds.size.width - width)/2
    
    uiData = UIData(name: "sett", width: width, colourOption: 0)
    uiData.updateColour(profile: 4)
    
    firstCardY = (UIScreen.main.bounds.height - (uiData.cardSize.height + uiData.statusBarSize.height * 2)) * 0.5
    statusBarH = uiData.statusBarSize.height
    
    topCardIndex = 2
    
    super.init(nibName: nil, bundle: nil)
    
    statsBarTapUIGR = UITapGestureRecognizer(target: self, action: #selector(statusBarTap))

    makeAndEmbedCards()
    setIcons()
    cardShuffleGesutre(enabled: false)
  }
  
  
  func makeAndEmbedCards() {
    cardViews.gameCardC = GameCardViewController(iName: "gameC", viewData: uiData, delegate: self)
    cardViews.settCardC = SettingsCardViewController(iName: "settC", viewData: uiData, delegate: self)
    cardViews.statCardC = StatsCardViewController(iName: "statC", viewData: uiData, delegate: self)
    
    cardViews.statCardC?.cardView.backgroundColor = uiData.colourD
    cardViews.settCardC?.cardView.backgroundColor = uiData.colourL
    cardViews.gameCardC?.cardView.backgroundColor = uiData.colourM

    self.embed(cardViews.statCardC!, inView: self.view, origin: CGPoint(x: 0, y: firstCardY))
    self.embed(cardViews.settCardC!, inView: self.view, origin: CGPoint(x: 0, y: firstCardY + uiData.statusBarSize.height))
    self.embed(cardViews.gameCardC!, inView: self.view, origin: CGPoint(x: 0, y: firstCardY + uiData.statusBarSize.height * 2))
    cardViews.gameCardC!.broughtToTop()
  }
  
  func unembedAndDeleteCards() {
    self.unembed(cardViews.gameCardC!, inView: self.view)
    self.unembed(cardViews.settCardC!, inView: self.view)
    self.unembed(cardViews.statCardC!, inView: self.view)
    cardViews.deleteCards()
  }
  
  
  func setIcons() {
    cardViews.settCardC?.updateIcon(internalName: "time", internalValue: settings!.time)
    cardViews.settCardC?.updateIcon(internalName: "lexicon", internalValue: settings!.lexicon)
    cardViews.settCardC?.updateIcon(internalName: "length", internalValue: settings!.minWordLength)
    cardViews.settCardC?.updateIcon(internalName: "tiles", internalValue: settings!.tileSqrt)
  }
  
  
  func reorderCardsByIndex(iName iN: String) {
    // TODO: Simplify.
    
    switch iN {
    case "gameC":
      cardViews.statCardC!.view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(0) * statusBarH))
      cardViews.settCardC!.view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(1) * statusBarH))
      cardViews.gameCardC!.view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(2) * statusBarH))
      cardViews.statCardC!.shuffledToDeck()
      cardViews.settCardC!.shuffledToDeck()
      cardViews.gameCardC!.broughtToTop()
      view.bringSubviewToFront(cardViews.statCardC!.view)
      view.bringSubviewToFront(cardViews.settCardC!.view)
      view.bringSubviewToFront(cardViews.gameCardC!.view)
    case "statC":
      cardViews.gameCardC!.view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(0) * statusBarH))
      cardViews.settCardC!.view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(1) * statusBarH))
      cardViews.statCardC!.view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(2) * statusBarH))
      cardViews.gameCardC!.shuffledToDeck()
      cardViews.settCardC!.shuffledToDeck()
      cardViews.statCardC!.broughtToTop()
      view.bringSubviewToFront(cardViews.gameCardC!.view)
      view.bringSubviewToFront(cardViews.settCardC!.view)
      view.bringSubviewToFront(cardViews.statCardC!.view)
    case "settC":
      cardViews.statCardC!.view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(0) * statusBarH))
      cardViews.gameCardC!.view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(1) * statusBarH))
      cardViews.settCardC!.view.frame.origin = CGPoint(x: 0, y: firstCardY + (CGFloat(2) * statusBarH))
      cardViews.statCardC!.shuffledToDeck()
      cardViews.gameCardC!.shuffledToDeck()
      cardViews.settCardC!.broughtToTop()
      view.bringSubviewToFront(cardViews.statCardC!.view)
      view.bringSubviewToFront(cardViews.gameCardC!.view)
      view.bringSubviewToFront(cardViews.settCardC!.view)
    default:
      return
    }
  }
  
  
  @objc func statusBarTap(_ r: UIGestureRecognizer) {
    let card = r.view?.superview as! CardView
    reorderCardsByIndex(iName: card.iName)
  }
  
  
  func rebuildStack() {
    unembedAndDeleteCards()
    makeAndEmbedCards()
    setIcons()
    cardShuffleGesutre(enabled: false)
    reorderCardsByIndex(iName: "settC")
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}



extension CardStackViewController: CardStackDelegate {
  
  func cardShuffleGesutre(enabled: Bool) {
    if enabled {
      cardViews.removeGesturesFromStatusBar()
    } else {
      cardViews.settCardC!.addGestureToStatusBar(gesture: UITapGestureRecognizer(target: self, action: #selector(statusBarTap)))
      cardViews.statCardC!.addGestureToStatusBar(gesture: UITapGestureRecognizer(target: self, action: #selector(statusBarTap)))
      cardViews.gameCardC!.addGestureToStatusBar(gesture: UITapGestureRecognizer(target: self, action: #selector(statusBarTap)))
    }
  }
  
  
  func updateSetting(internalName: String, internalValue: Int16) {
    print("Ah, to change")
    
    switch internalName {
      
    case "impact":
      uiData.impact = (internalValue == 1) ?  true : false
    case "side":
      uiData.leftSide = (internalValue == 1) ?  true : false
      rebuildStack()
    case "colour":
      print("whoa, colour")
      rebuildStack()
      
    case "time", "lexicon", "length", "tiles":
      
      updateNonMutatingSetting(internalName: internalName, internalValue: internalValue)
      
    default:
      break
    }
  }
  
  
  func processUpdate() {
    print("Asked to process update")
    cardViews.statCardC!.respondToUpdate()
  }
  
  
  func currentSettings() -> Settings {
    return settings!
  }
  
  
  func currentGame() -> GameInstance? {
    return settings!.currentGame
  }
  
  
  func currentStats() -> StatsCollection {
    return settings!.stats!
  }
}


extension CardStackViewController {
  
  func updateNonMutatingSetting(internalName: String, internalValue: Int16) {
    // Nonmutating means loading or creating settings which match chnage to internalName.
    
    
    // First, get the values of the current settings.
    // There's always *a* settings file, so these are fine to get.
    // Use these to perform a search.
    if let currentSetitngs = settings {
      
      var lexiconVal = currentSetitngs.lexicon
      var minWordVal = currentSetitngs.minWordLength
      var tileSqrtVal = currentSetitngs.tileSqrt
      var timeVal = currentSetitngs.time
      
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
          settings = nil
          settings = (result.first as! Settings)
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
          settings = nil
          settings = freshSettings
          settings!.ensureDefaults()
          print("Search okay, no setting found")
        }
      } catch {
        print("Search failed")
      }
    } else {
      print("Woooow")
    }
    setIcons()
  }
  
  
  
}
