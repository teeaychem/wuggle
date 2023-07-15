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
  private let cardX: CGFloat
  private let statusBarH: CGFloat
  
  private var statsBarTapUIGR: UIGestureRecognizer?
  
  private var cardViews = cardViewsStruct()
  private var cardOrigin: CGFloat = 0.0
  private var topCardIndex: Int
  
  // TODO: Understand what happens with this.
  // If settings is initialised on SceneDelegate, this is an unowned var.
  // So, it's possible reference to settings fails.
  // This makes sense.
  // But, at no point should the reference fail, unless settings as stored on unowned var is distinct from settings as stored on var in SceneDelegate.
  // So, perhaps this is the case.
  // And, when unowned var is changed, this doesn't lead to an immediate change with original var.
  var settings: Settings?
  
  init() {
    
    width = min(((UIScreen.main.bounds.size.height) / 1.4 / 1.16 ) * 0.9, UIScreen.main.bounds.size.width)
    cardIndent = (UIScreen.main.bounds.size.width - width)/2
    
    uiData = UIData(width: width)
    uiData.loadFromCore()
    
    firstCardY = (UIScreen.main.bounds.height - (uiData.cardSize.height + uiData.statusBarSize.height * 2)) * 0.5
    cardX = (UIScreen.main.bounds.width - uiData.cardSize.width) * 0.5
    statusBarH = uiData.statusBarSize.height
    
    topCardIndex = 2
    
    super.init(nibName: nil, bundle: nil)
    
    settings = loadOrMakeSettings()
    settings!.ensureDefaults()
    
    statsBarTapUIGR = UITapGestureRecognizer(target: self, action: #selector(statusBarTap))

//    self.makeAndEmbedCards()
//    self.setIcons()
//    self.cardShuffleGesutre(enabled: true)
  }
  
  
  override func viewDidLoad() {
      self.ensureTrie()
  }
  
  
  func loadOrMakeSettings() -> Settings {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let settingsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
    do {
      let result = try context.fetch(settingsFetchRequest)
      
      if result.count > 0 {
        return (result.first as! Settings)
        // TODO: Delete other instances.
      } else {
        // If nothing found, default settings.
        let dSettings = Settings(context: context)
        dSettings.stats = StatsCollection(context: context)
        return dSettings
      }
    } catch {
      // If load fails, things should be fine with default settings.
      let dSettings = Settings(context: context)
      dSettings.stats = StatsCollection(context: context)
      return dSettings
    }
  }
  
  
  func makeAndEmbedCards() {
    cardViews.gameCardC = GameCardViewController(iName: "gameC", viewData: uiData, delegate: self)
    cardViews.settCardC = SettingsCardViewController(iName: "settC", viewData: uiData, delegate: self)
    cardViews.statCardC = StatsCardViewController(iName: "statC", viewData: uiData, delegate: self)
    
    cardViews.statCardC?.cardView.backgroundColor = uiData.colourD
    cardViews.settCardC?.cardView.backgroundColor = uiData.colourL
    cardViews.gameCardC?.cardView.backgroundColor = uiData.colourM

    self.embed(cardViews.statCardC!, inView: self.view, origin: CGPoint(x: cardX, y: firstCardY))
    self.embed(cardViews.settCardC!, inView: self.view, origin: CGPoint(x: cardX, y: firstCardY + uiData.statusBarSize.height))
    self.embed(cardViews.gameCardC!, inView: self.view, origin: CGPoint(x: cardX, y: firstCardY + uiData.statusBarSize.height * 2))
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
    // There's a lot of repitation here.
    // In short, settings card is centre unless, settings is chosen, then stats > game > settings.
    
    switch iN {
    case "gameC":
      cardViews.statCardC!.view.frame.origin = CGPoint(x: cardX, y: firstCardY + (CGFloat(0) * statusBarH))
      cardViews.settCardC!.view.frame.origin = CGPoint(x: cardX, y: firstCardY + (CGFloat(1) * statusBarH))
      cardViews.gameCardC!.view.frame.origin = CGPoint(x: cardX, y: firstCardY + (CGFloat(2) * statusBarH))
      cardViews.statCardC!.shuffledToDeck()
      cardViews.settCardC!.shuffledToDeck()
      cardViews.gameCardC!.broughtToTop()
      view.bringSubviewToFront(cardViews.statCardC!.view)
      view.bringSubviewToFront(cardViews.settCardC!.view)
      view.bringSubviewToFront(cardViews.gameCardC!.view)
    case "statC":
      cardViews.gameCardC!.view.frame.origin = CGPoint(x: cardX, y: firstCardY + (CGFloat(0) * statusBarH))
      cardViews.settCardC!.view.frame.origin = CGPoint(x: cardX, y: firstCardY + (CGFloat(1) * statusBarH))
      cardViews.statCardC!.view.frame.origin = CGPoint(x: cardX, y: firstCardY + (CGFloat(2) * statusBarH))
      cardViews.gameCardC!.shuffledToDeck()
      cardViews.settCardC!.shuffledToDeck()
      cardViews.statCardC!.broughtToTop()
      view.bringSubviewToFront(cardViews.gameCardC!.view)
      view.bringSubviewToFront(cardViews.settCardC!.view)
      view.bringSubviewToFront(cardViews.statCardC!.view)
    case "settC":
      cardViews.statCardC!.view.frame.origin = CGPoint(x: cardX, y: firstCardY + (CGFloat(0) * statusBarH))
      cardViews.gameCardC!.view.frame.origin = CGPoint(x: cardX, y: firstCardY + (CGFloat(1) * statusBarH))
      cardViews.settCardC!.view.frame.origin = CGPoint(x: cardX, y: firstCardY + (CGFloat(2) * statusBarH))
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
    cardShuffleGesutre(enabled: true)
    reorderCardsByIndex(iName: "settC")
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


// MARK: CardStackDelegate

extension CardStackViewController: CardStackDelegate {
  
  func cardShuffleGesutre(enabled: Bool) {
    if enabled {
      cardViews.settCardC!.addGestureToStatusBar(gesture: UITapGestureRecognizer(target: self, action: #selector(statusBarTap)))
      cardViews.statCardC!.addGestureToStatusBar(gesture: UITapGestureRecognizer(target: self, action: #selector(statusBarTap)))
      cardViews.gameCardC!.addGestureToStatusBar(gesture: UITapGestureRecognizer(target: self, action: #selector(statusBarTap)))
    } else {
      cardViews.removeGesturesFromStatusBar()
    }
  }
  
  
  func updateSetting(internalName: String, internalValue: Int16) {
    
    switch internalName {
    case "impact":
      uiData.impact = (internalValue == 1) ?  true : false
    case "side":
      uiData.leftSide = (internalValue == 1) ?  true : false
      // TODO: Maybe. Only need to redo gameCard here, rather than everything.
      rebuildStack()
    case "colour":
      uiData.updateColour(profile: internalValue)
      rebuildStack()
    case "pfound":
      uiData.showPercent = (internalValue == 1) ?  true : false
      if (currentGame() != nil) {
        cardViews.gameCardC!.combinedScoreViewC.gameInstanceUpdate(instance: currentGame()!, obeySP: true)
      }
    case "time", "lexicon", "length", "tiles":
      updateNonMutatingSetting(internalName: internalName, internalValue: internalValue)
      setIcons()
    default:
      break
    }
    uiData.saveToCore()
  }
  
  
  func processUpdate() {
    print("Asked to process update")
    cardViews.statCardC!.respondToUpdate()
    cardViews.gameCardC!.respondToUpdate()
  }
  
  
  func currentSettings() -> Settings {
    return settings!
  }
  
  
  func currentGame() -> GameInstance? {
    guard settings != nil else {
      return GameInstance(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
    return settings!.currentGame
  }
  
  
  func currentStats() -> StatsCollection {
    return settings!.stats!
  }
}


extension CardStackViewController {
  
  private func updateNonMutatingSetting(internalName: String, internalValue: Int16) {
    // Nonmutating means loading or creating settings which match chnage to internalName.
    
    // First, get the values of the current settings.
    // There's always *a* settings file, so these are fine to get.
    // Use these to perform a search.
    if let currentSettings = settings {
      var lexiconVal = currentSettings.lexicon
      var minWordVal = currentSettings.minWordLength
      var tileSqrtVal = currentSettings.tileSqrt
      var timeVal = currentSettings.time
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
          settings = freshSettings
          settings!.ensureDefaults()
        }
      } catch { }
    }
  }
  
  
  func ensureTrie() {
    
      
      let privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return managedObjectContext
      }()
      
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrieNode")
      fetchRequest.fetchLimit = 1
      
      if let result = try? privateManagedObjectContext.fetch(fetchRequest) {
        if result.count < 1 {
          print("making tries")
          privateManagedObjectContext.perform {
            let newTrie = TrieNode(context: privateManagedObjectContext)
            newTrie.completeTrieFromFile(fName: "3of6game", lexiconIndex: 0, context: privateManagedObjectContext)
            do {
              try privateManagedObjectContext.parent!.save()
            } catch {
              print("heck")
            }
            newTrie.completeTrieFromFile(fName: "Odgen", lexiconIndex: 1, context: privateManagedObjectContext)
            do {
              try privateManagedObjectContext.parent!.save()
            } catch {
              print("heck")
            }
            newTrie.completeTrieFromFile(fName: "Austen", lexiconIndex: 2, context: privateManagedObjectContext)
            do {
              try privateManagedObjectContext.parent!.save()
            } catch {
              print("heck")
            }
            newTrie.completeTrieFromFile(fName: "KJB", lexiconIndex: 3, context: privateManagedObjectContext)
            do {
              try privateManagedObjectContext.parent!.save()
            } catch {
              print("heck")
            }
            newTrie.completeTrieFromFile(fName: "Shakespeare", lexiconIndex: 4, context: privateManagedObjectContext)
            print("done making tries")
            do {
              try privateManagedObjectContext.parent!.save()
            } catch {
              print("heck")
            }
            print("done")
            self.performSelector(onMainThread: #selector(self.trieSuccess), with: nil, waitUntilDone: true)
          }
        }
      }
  }
  
  
  @objc func trieSuccess(){
    print("notified")
    self.makeAndEmbedCards()
    self.setIcons()
    self.cardShuffleGesutre(enabled: true)
  }
}
