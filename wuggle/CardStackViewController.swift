//
//  CardStackViewController.swift
//  wuggle
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
  
  // As settings is initialised on SceneDelegate, this is an unowned var.
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
  }
  
  
  override func viewDidLoad() {
    let sWidth = UIScreen.main.bounds.size.width
    let tileSize = CGSize(width: sWidth * 0.25, height: sWidth * 0.25)
    let tileView = UIView(frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.size.width * 0.5 -  tileSize.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5 - tileSize.height * 0.5), size: tileSize))
    let tileLayer = CAShapeLayer()
    tileLayer.strokeColor = UIColor.white.cgColor
    tileLayer.path = randomStartRoundedUIBeizerPath(width: tileSize.width, height: tileSize.height, cornerRadius: tileSize.width * 0.25).cgPath
    tileView.layer.addSublayer(tileLayer)
    view.addSubview(tileView)
    let blockingLayer = CAShapeLayer()
    blockingLayer.strokeColor = UIColor.black.cgColor
    blockingLayer.path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: tileView.frame.width * 0.1, y: tileView.frame.height * 0.1), size: CGSize(width: tileView.frame.width * 0.75, height: tileView.frame.width * 0.75))).cgPath
    blockingLayer.frame.origin = CGPoint(x: tileView.frame.width * 0.5, y: tileView.frame.height * 0.5)
    tileView.layer.addSublayer(blockingLayer)
    
    let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotation.toValue = -Double.pi * 2
    rotation.duration = 8
    rotation.isCumulative = false
    rotation.repeatCount = MAXFLOAT
    blockingLayer.add(rotation, forKey: "rotationAnimation")
    
    self.ensureTrie()
  }
  
  
  func loadOrMakeSettings() -> Settings {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let settingsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
    settingsFetchRequest.predicate = NSPredicate(format: "inUse == true")
    // Should only be one inUse
    settingsFetchRequest.fetchLimit = 1
    do {
      let result = try context.fetch(settingsFetchRequest)
      
      if result.count > 0 {
        return (result.first as! Settings)
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
    cardViews.gameCardC = GameCardViewController(iName: "gameC", uiData: uiData, delegate: self)
    cardViews.settCardC = SettingsCardViewController(iName: "settC", uiData: uiData, delegate: self)
    cardViews.statCardC = StatsCardViewController(iName: "statC", uiData: uiData, delegate: self)
    
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
    // There's a lot of repitation here. May be possible to simplify.
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
    if uiData.impact { UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5) }
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
  
  
  func updateGeneralSettings(internalName: String, internalValue: Int16) {
    
    switch internalName {
    case "impact":
      uiData.impact = (internalValue == 1) ?  true : false
    case "side":
      uiData.leftSide = (internalValue == 1) ?  true : false
      // Maybe. Only need to redo gameCard here, rather than everything.
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
      updateNonUISetting(internalName: internalName, internalValue: internalValue)
      setIcons()
    default:
      break
    }
    uiData.saveToCore()
  }
  
  
  func processUpdate() {
    settings?.makeASave()
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
  
  private func updateNonUISetting(internalName: String, internalValue: Int16) {
    // This is more complex.
    // The update involves switching to a different settings instance, or creating
    // the appropriate instance as required.
    // In addition, work needs to be done to ensure there's a unique default settings
    // file to be loaded with the app.
    
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
          settings?.inUse = false
          settings = (result.first as! Settings)
        } else if result.count > 1 {
          // Something went wrong somewhere, so wipe the inUse from all and go with first.
          for iU in result {
            let iUS = iU as! Settings
            iUS.inUse = false
          }
          settings = (result.first as! Settings)
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
        // Clean things up
        // We've updated the settings, so now we make sure any other settings
        // instance in coredata is not in use, then fix the current settings.
        let inUseSettingsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        inUseSettingsFetchRequest.predicate = NSPredicate(format: "inUse == true")
        do {
          let inUseResult = try context.fetch(inUseSettingsFetchRequest)
          if inUseResult.count > 0 {
            for iU in inUseResult {
              let iUS = iU as! Settings
              iUS.inUse = false
            }
          }
        } catch { }
        settings?.inUse = true
      } catch { }
    }
  }
  
  
  func ensureTrie() {
    // Build the tries on background thread then notify main thread to move to main UI
      let prvMngdObjCntxt: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return managedObjectContext
      }()
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrieNode")
      fetchRequest.fetchLimit = 1
      if let result = try? prvMngdObjCntxt.fetch(fetchRequest) {
        if result.count > 0 {
          prvMngdObjCntxt.perform {
            let rootTrie = (result.first as! TrieNode).getRoot()!
            
            if !rootTrie.memoryContainsWord(word: "PROCRASTINATION", lexicon: 0) {
              self.buildAndSave(root: rootTrie, fileName: "3of6game", prvCntxt: prvMngdObjCntxt, index: 0)
            }
            if !rootTrie.memoryContainsWord(word: "GOVERNMENT", lexicon: 1) {
              self.buildAndSave(root: rootTrie, fileName: "Odgen", prvCntxt: prvMngdObjCntxt, index: 1)
            }
            if !rootTrie.memoryContainsWord(word: "ZIGZAGS", lexicon: 2) {
              self.buildAndSave(root: rootTrie, fileName: "Austen", prvCntxt: prvMngdObjCntxt, index: 2)
            }
            if !rootTrie.memoryContainsWord(word: "HAZO", lexicon: 3) {
              self.buildAndSave(root: rootTrie, fileName: "KJB", prvCntxt: prvMngdObjCntxt, index: 3)
            }
            if !rootTrie.memoryContainsWord(word: "NEC", lexicon: 4) {
              self.buildAndSave(root: rootTrie, fileName: "Shakespeare", prvCntxt: prvMngdObjCntxt, index: 4)
            }
            self.performSelector(onMainThread: #selector(self.trieSuccess), with: nil, waitUntilDone: true)
          }
        } else {
          prvMngdObjCntxt.perform {
            let newTrie = TrieNode(context: prvMngdObjCntxt)
            self.buildAndSave(root: newTrie, fileName: "3of6game", prvCntxt: prvMngdObjCntxt, index: 0)
            self.buildAndSave(root: newTrie, fileName: "Odgen", prvCntxt: prvMngdObjCntxt, index: 1)
            self.buildAndSave(root: newTrie, fileName: "Austen", prvCntxt: prvMngdObjCntxt, index: 2)
            self.buildAndSave(root: newTrie, fileName: "KJB", prvCntxt: prvMngdObjCntxt, index: 3)
            self.buildAndSave(root: newTrie, fileName: "Shakespeare", prvCntxt: prvMngdObjCntxt, index: 4)
            self.performSelector(onMainThread: #selector(self.trieSuccess), with: nil, waitUntilDone: true)
          }
        }
      }
  }
  
  
  func buildAndSave(root: TrieNode, fileName fName: String, prvCntxt prC: NSManagedObjectContext, index i: Int) {
    root.completeTrieFromFile(fName: fName, lexiconIndex: i, context: prC)
    do { try prC.parent!.save() } catch { }
  }
  
  
  
  @objc func trieSuccess(){
    for sv in view.subviews {
      sv.layer.removeAllAnimations()
      sv.removeFromSuperview()
    }
    self.makeAndEmbedCards()
    self.setIcons()
    self.cardShuffleGesutre(enabled: true)
  }
  
  
  func issuePause() {
    cardViews.gameCardC?.pauseGameMain(animated: false)
  }
}
