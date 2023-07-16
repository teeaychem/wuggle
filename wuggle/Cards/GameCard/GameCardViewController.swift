//
//  GameCardViewController.swift
//  wuggle
//
//  Created by sparkes on 2023/06/24.
//
// Card for the gameview.

import UIKit
import CoreData

class GameCardViewController: CardViewController {
  
  let combinedScoreViewC: CombinedScoreViewController

  let boardViewController: GameboardViewController
  let stopwatchViewController: StopwatchViewController
  let playButtonsViewController: PlayButtonsViewController
  let foundWordsViewController: FoundWordsViewController
  var finalWordsViewController: FinalFoundWordsViewController?
  
  var watchGestureRecognizer: UITapGestureRecognizer?
  var boardPanGR: TouchToPanGestureRecognizer?
  var playPauseGR: UITapGestureRecognizer?
  var stopGR: UILongPressGestureRecognizer?
  
  var displayLinkOne: CADisplayLink?
  var displayLinkTwo: CADisplayLink?
  var displayLinkOneTimeElapsed = Double(0)
  var displayLinkTwoTimeElapsed = Double(0)
  
  var gameInProgess = false
    
  var selectedTiles = [Int16]()
  var rootTrie: TrieNode?
  
  override init(iName iN: String, uiData uiD: UIData, delegate d: CardStackDelegate) {
    
    // Icons
    combinedScoreViewC = CombinedScoreViewController(uiData: uiD, gameCard: true)
    
    // Fix controllers  for the current views
    boardViewController = GameboardViewController(uiData: uiD, tilePadding: uiD.tilePadding)
    stopwatchViewController = StopwatchViewController(uiData: uiD)
    playButtonsViewController = PlayButtonsViewController(uiData: uiD)
    foundWordsViewController = FoundWordsViewController(uiData: uiD)
    
    super.init(iName: iN, uiData: uiD, delegate: d)
    
    embed(combinedScoreViewC, inView: self.statusBarView, origin: CGPoint(x: 0, y: 0))
  }
  
  
  override func broughtToTop() {
    super.broughtToTop()
    
    // Use delegate to fix root trie.
    // This means it should be possible to init the controller before tries have been built, so long as the card is not pulled to the top.
    rootTrie = delegate!.currentSettings().getTrieRoot()
    
    // First set the views.
    self.embed(boardViewController, inView: self.cardView, origin: CGPoint(x: uiData.gameBoardPadding, y: uiData.cardSize.height - (uiData.gameBoardSize + uiData.gameBoardPadding)))
    
    if uiData.leftSide {
      self.embed(stopwatchViewController, inView: self.cardView, origin: CGPoint(x: uiData.gameBoardPadding, y: uiData.gameBoardPadding + uiData.statusBarSize.height))
      self.embed(playButtonsViewController, inView: self.cardView, origin: CGPoint(x: (2 * uiData.gameBoardPadding + uiData.stopWatchSize), y: (uiData.gameBoardPadding + uiData.statusBarSize.height)))
      self.embed(foundWordsViewController, inView: self.cardView, origin: CGPoint(x: ((3 * uiData.gameBoardPadding) + (1.5 * uiData.stopWatchSize)), y: (uiData.gameBoardPadding + uiData.statusBarSize.height)))
    } else {
      self.embed(foundWordsViewController, inView: self.cardView, origin: CGPoint(x: uiData.gameBoardPadding, y: (uiData.gameBoardPadding + uiData.statusBarSize.height)))
      self.embed(playButtonsViewController, inView: self.cardView, origin: CGPoint(x: (2 * uiData.gameBoardPadding + uiData.foundWordViewWidth), y: (uiData.gameBoardPadding + uiData.statusBarSize.height)))
      self.embed(stopwatchViewController, inView: self.cardView, origin: CGPoint(x: 3 * uiData.gameBoardPadding + uiData.foundWordViewWidth + uiData.stopWatchSize * 0.5, y: uiData.gameBoardPadding + uiData.statusBarSize.height))
    }
    // Always want play/pause GR
    addPlayPauseGR()
    
    if delegate!.currentGame() != nil {
      // There's a game.
      boardViewController.createAllTileViews(board: delegate!.currentGame()!.board!)
      stopwatchViewController.setHandTo(percent: delegate!.currentGame()!.timeUsedPercent)
      for word in delegate!.currentGame()!.foundWordsList! {
        foundWordsViewController.update(word: word, found: true)
      }
      boardViewController.displayTileFoundationAll()
      
      if delegate!.currentGame()!.viable {
        // Game is viable
        // Play/pause via watch
        addWatchGR()
        // Stop is possible.
        playButtonsViewController.paintStopIcon()
        // Game is viable so watch and stop gr
        addStopGR()
        // Play pause isn't new game.
        playButtonsViewController.paintPlayIcon()
      } else {
        // Else, set things as if the game had just ended.
        endGameMain(fresh: false)
      }
    } else {
      // There's no game.
      // playPause GR is active, so just display newGame icon.
      playButtonsViewController.displayNewGameIcon()
    }
  }
  
  
  override func shuffledToDeck() {
    
    pauseGameMain(animated: false)
    
    self.unembed(boardViewController, inView: self.cardView)
    self.unembed(stopwatchViewController, inView: self.cardView)
    self.unembed(playButtonsViewController, inView: self.cardView)
    self.unembed(foundWordsViewController, inView: self.cardView)
    
    if finalWordsViewController != nil {
      self.unembed(finalWordsViewController!, inView: self.cardView)
    }
    
    boardViewController.removeAllGestureRecognizers()
    stopwatchViewController.removeAllGestureRecognizers()
    playButtonsViewController.removeAllGestureRecognizers()
    
    foundWordsViewController.clear()
    boardViewController.removeAllTileViews()
    playButtonsViewController.hideStopIcon()
    
    super.shuffledToDeck()
  }
  
  
  override func respondToUpdate() {
    if delegate?.currentGame() != nil {
      combinedScoreViewC.gameInstanceUpdate(instance: delegate!.currentGame()!, obeySP: true)
      stopwatchViewController.setHandTo(percent: delegate!.currentGame()!.timeUsedPercent)
    } else {
      combinedScoreViewC.combinedUpdate(found: 0, score: 0, percent: 0, obeySP: true)
      stopwatchViewController.setHandTo(percent: 0)
    }
  }
  
  
  func stringFromSelectedTiles() -> String {
    var builtString = ""
    
    for tileIndex in selectedTiles {
      builtString += boardViewController.gameboardView.tiles[tileIndex]?.text ?? ""
    }
    return builtString.replacingOccurrences(of: "Qu", with: "!")
  }
  
  
  func isAccessibleTile(fromIndex: Int16, toIndex: Int16) -> Bool {
    // Check to see is tile is accessible.
    let fromTilePair = boardViewController.tileLocationSplit(combined: fromIndex)
    let toTilePair = boardViewController.tileLocationSplit(combined: toIndex)
    let rowAccess = ((toTilePair.0 - 2) < fromTilePair.0) && (fromTilePair.0 < (toTilePair.0 + 2))
    let colAccess = ((toTilePair.1 - 2) < fromTilePair.1) && (fromTilePair.1 < (toTilePair.1 + 2))
    return rowAccess && colAccess
  }
  
  
  func processWord(word w: String) {
    
    guard rootTrie != nil else { return }
    
    let endTrie = rootTrie!.traceString(word: w)
    if (endTrie != nil && endTrie!.isWord && endTrie!.lexiconList![Int(delegate!.currentSettings().lexicon)] && w.count >= delegate!.currentSettings().minWordLength) {
      
      let fixedWord = w.replacingOccurrences(of: "!", with: "Qu")
      
      foundWordsViewController.update(word: w, found: true)
      if delegate?.currentGame()?.foundWordsList == nil {
        delegate?.currentGame()?.foundWordsList = [w]
      } else {
        if delegate!.currentGame()!.foundWordsList!.contains(w) {
          return
        } else {
          delegate!.currentGame()?.foundWordsList!.append(w)
          delegate!.currentGame()?.foundWordCount += 1
          delegate!.currentGame()?.pointsCount += Int16(getPoints(word: w))
          combinedScoreViewC.gameInstanceUpdate(instance: delegate!.currentGame()!, obeySP: true)
          thinkAboutStats(word: w)
        }
      }
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}



// MARK: Starting, pausing, and ending a game
extension GameCardViewController {
  
  func newGameMain() {
    if uiData.impact {
      UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 0.75)
    }
    // Remove things from previous game.
    boardViewController.removeAllTileViews()
    foundWordsViewController.clear()
    if (finalWordsViewController != nil) {
      self.unembed(finalWordsViewController!, inView: self.cardView)
      finalWordsViewController = nil
    }
    combinedScoreViewC.combinedUpdate(found: 0, score: 0, percent: 0, obeySP: true)
    // Pause interaction while setting up a new game
    removePlayPauseGR()
    delegate!.cardShuffleGesutre(enabled: false)
    // Get a new game.
    delegate?.currentSettings().setNewGame()
    boardViewController.createAllTileViews(board: delegate!.currentGame()!.board!)
    // Set a timer and call a wait function.
    // In part for finding possible words, and in part for good feels.
    displayLinkTwo = CADisplayLink(target: self, selector: #selector(newGameWait))
    displayLinkTwo!.add(to: .current, forMode: .common)
    // Most UI stuff is updated after waiting, but watch looks good immediate.
    stopwatchViewController.setHandTo(percent: delegate!.currentSettings().time > 0 ? 0 : -1)
    
    // As part of this function we load up a private managed context which runs on a different thread.
    // This then works on the settings file separately from the settings in use on the main thread.
    // Perform means that we don't wait around for what is requested.
    // Saving then merges the two contexts.
    
    let privateManagedObjectContext: NSManagedObjectContext = {
      let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
      managedObjectContext.parent = self.delegate!.currentSettings().managedObjectContext
      return managedObjectContext
    }()
          
    let settingsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
    
    settingsFetchRequest.predicate = NSPredicate(
      format: "time == %i AND lexicon == %i AND minWordLength == %i AND tileSqrt == %i",
      delegate!.currentSettings().time, delegate!.currentSettings().lexicon, delegate!.currentSettings().minWordLength, delegate!.currentSettings().tileSqrt)
    
      settingsFetchRequest.fetchLimit = 1
      if let result = try? privateManagedObjectContext.fetch(settingsFetchRequest) {
        let settings = result.first as! Settings
        privateManagedObjectContext.perform {
          settings.currentGame!.findPossibleWords(minLength: Int(self.delegate!.currentSettings().minWordLength))
          do {
            try privateManagedObjectContext.save()
          } catch {  }
        }
      }
  }
  
  
  @objc func newGameWait() {
       
    if displayLinkTwoTimeElapsed < 1 {
      // Count up while animating the new game icon
      displayLinkTwoTimeElapsed += displayLinkTwo!.targetTimestamp - displayLinkTwo!.timestamp
      
      playButtonsViewController.rotatePlayPauseIcon(percent: displayLinkTwoTimeElapsed)
      for tile in boardViewController.gameboardView.tiles.values {
        tile.partialDiplayTile(percent: displayLinkTwoTimeElapsed)
      }
    } else {
      // Clear the timer
      displayLinkTwo?.invalidate()
      displayLinkTwoTimeElapsed = 0
      // Fix the icons.
      playButtonsViewController.paintPlayIcon()
      playButtonsViewController.paintStopIcon()
      // Add gesture recognisers
      addWatchGR()
      addPlayPauseGR()
      addStopGR()
      
      boardViewController.displayTileFoundationAll()
      delegate!.cardShuffleGesutre(enabled: true)
      
      // Go straight into the new game
      resumeGameMain()
    }
  }
  
  
  func resumeGameMain() {
    boardViewController.displayTileCharacterAll(animated: true)
    displayLinkOne = CADisplayLink(target: self, selector: #selector(Counting))
    displayLinkOne!.add(to: .current, forMode: .common)
    boardViewController.removeAllGestureRecognizers()
    addBoardPanGR()
    playButtonsViewController.paintPauseIcon()
    gameInProgess = true
  }
  
  
  func pauseGameMain(animated a: Bool) {
    displayLinkOne?.invalidate()
    boardViewController.hideAllTiles(animated: a)
    playButtonsViewController.paintPlayIcon()
    boardViewController.removeAllGestureRecognizers()
    gameInProgess = false
  }
  
  
  func endGameMain(fresh: Bool) {
    
    if (!delegate!.currentGame()!.allWordsComplete) {
      // There a chance possible words failed to complete.
      // If so, pause the game here to fill everything in.
      delegate!.currentGame()?.findPossibleWords(minLength: Int(delegate!.currentSettings().minWordLength))
    }
    endGameDisplay()
    // Cancel timer, pause and end game
    displayLinkOne?.invalidate()
    gameInProgess = false
    boardViewController.displayTileCharacterAll(animated: false)
    
    if fresh {
      // Only interact with coreData is fresh game over
      thinkingAboutStats(game: delegate!.currentGame()!)
      delegate!.currentGame()?.viable = false
    }
  }
  
  
  func endGameDisplay() {
    boardViewController.setOpacity(to: 0.25)
    // Update buttons
    playButtonsViewController.hideStopIcon()
    playButtonsViewController.displayNewGameIcon()
    // Remove gestures
    boardViewController.removeAllGestureRecognizers()
    removeWatchGR()
    // Display final words
    finalWordsViewController = FinalFoundWordsViewController(uiData: uiData)
    self.embed(finalWordsViewController!, inView: self.cardView, origin: CGPoint(x: uiData.gameBoardPadding + uiData.gameBoardSize * 0.075, y: uiData.cardSize.height - uiData.gameBoardSize * 0.925 - uiData.gameBoardPadding))
    finalWordsViewController?.addNoseeWordsDiff(noseeWords: (delegate!.currentGame()!.allWordsList!), seeWords: delegate!.currentGame()!.foundWordsList!)
    // Add gesture to see board.
    boardViewController.addGestureRecognizer(recogniser: UILongPressGestureRecognizer(target: self, action: #selector(didLongPressBoard)))
  }
}

// MARK: Checking stats
extension GameCardViewController {
  
  func thinkAboutStats(word w: String) {
    // Check each stat associated with a single word
    let wordLength = Double(w.count)
    let wordPoints = Double(getPoints(word: w))
    let ratio = wordPoints/wordLength
    
    if wordLength > delegate!.currentStats().topWordLength!.numVal {
      delegate!.currentStats().topWordLength!.numVal = wordLength
      delegate!.currentStats().topWordLength!.strVal = w.capitalized
      delegate!.currentStats().topWordLength!.extraStr = String(w.count) + " characters"
      delegate!.currentStats().topWordLength!.date = Date()
    }
    if wordPoints > delegate!.currentStats().topWordPoints!.numVal {
      delegate!.currentStats().topWordPoints!.numVal = wordPoints
      delegate!.currentStats().topWordPoints!.strVal = w.capitalized
      delegate!.currentStats().topWordPoints!.extraStr = String(Int(wordPoints)) + " points"
      delegate!.currentStats().topWordPoints!.date = Date()
    }
    if ratio > delegate!.currentStats().topRatio!.numVal {
      delegate!.currentStats().topRatio!.numVal = ratio
      delegate!.currentStats().topRatio!.strVal = w.capitalized
      delegate!.currentStats().topRatio!.extraStr = String(format: "%.2f on average", ratio)
      delegate!.currentStats().topRatio!.date = Date()
    }
  }
  
  
  func thinkingAboutStats(game g: GameInstance) {
    // Check each state associated with a game instance
    let foundWordCount = Double(g.foundWordsList!.count)
    let pointsCollected = Double(g.pointsCount)
    let percentFound = Double(foundWordCount) / Double(g.allWordsList!.count) * 100
    
    if foundWordCount > delegate!.currentStats().topWords!.numVal {
      delegate!.currentStats().topWords!.numVal = foundWordCount
      delegate!.currentStats().topWords!.strVal = String(Int(foundWordCount))
      delegate!.currentStats().topWords!.extraStr = "For " + String(Int(pointsCollected)) + " points"
      delegate!.currentStats().topWords!.date = Date()
      delegate!.processUpdate()
    }
    
    if pointsCollected > delegate!.currentStats().topPoints!.numVal {
      delegate!.currentStats().topPoints!.numVal = pointsCollected
      delegate!.currentStats().topPoints!.strVal = String(Int(pointsCollected))
      delegate!.currentStats().topPoints!.extraStr = "In " + String(Int(foundWordCount)) + " words"
      delegate!.currentStats().topPoints!.date = Date()
      delegate!.processUpdate()
    }
    
    if percentFound > delegate!.currentStats().topPercent!.numVal {
      delegate!.currentStats().topPercent!.numVal = percentFound
      delegate!.currentStats().topPercent!.strVal = String(Int(percentFound))
      delegate!.currentStats().topPercent!.extraStr = String(Int(foundWordCount)) + " out of " + String(delegate!.currentGame()!.allWordsList!.count) + " words "
      delegate!.currentStats().topPercent!.date = Date()
      delegate!.processUpdate()
    }
  }
  
}


// MARK: GestureRecognisers
extension GameCardViewController {
  
  
  func addPlayPauseGR() {
    if (playPauseGR == nil) {
      playPauseGR = UITapGestureRecognizer(target: self, action: #selector(didTapOnPlayPause(_:)))
    }
    playButtonsViewController.playPauseAddGesture(gesture: playPauseGR!)
  }
  
  func removePlayPauseGR() {
    if (playPauseGR != nil) {
      playButtonsViewController.playPauseRemoveGesture(gesture: playPauseGR!)
    }
  }
  
  
  func addStopGR() {
    if (stopGR == nil) {
      stopGR = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressStop(_:)))
      stopGR!.minimumPressDuration = 0.05
    }
    playButtonsViewController.stopAddGesture(gesture: stopGR!)
  }
  
  
  func addWatchGR() {
    if (watchGestureRecognizer == nil) {
      watchGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnTime(_:)))
    }
    stopwatchViewController.view.addGestureRecognizer(watchGestureRecognizer!)
  }
  
  
  func removeWatchGR() {
    if (watchGestureRecognizer != nil) {
      stopwatchViewController.view.removeGestureRecognizer(watchGestureRecognizer!)
    }
  }
  
  
  func addBoardPanGR() {
    if (boardPanGR == nil) {
      boardPanGR = TouchToPanGestureRecognizer(target: self, action: #selector(didPanOnBoard(_:)))
//      boardPanGR!.maximumNumberOfTouches = 1
    }
    boardViewController.addGestureRecognizer(recogniser: boardPanGR!)
  }
  
  
  @objc func didPanOnBoard(_ sender: UIPanGestureRecognizer) {
    
    let tilePosition = boardViewController.basicTilePositionFromCGPoint(point: sender.location(in: boardViewController.gameboardView), tileSqrtFloat: CGFloat((delegate?.currentSettings().tileSqrt)!))
    
    switch sender.state {
    case .began:
      // On start, set up trieRoot.
      // And, if in a tile, set initial tile.
      if (tilePosition != nil) {
        boardViewController.selectTile(tileIndex: tilePosition!)
        selectedTiles.append(tilePosition!)
        if uiData.impact { UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.75) }
      }
      
    case .changed:
      // Check to see if we've got a tile to inspect.
      if (tilePosition != nil) {
        // Check to see if there are already selected tiles.
        if selectedTiles.count > 0 {
          // Check we're at an accessible tile.
          if (isAccessibleTile(fromIndex: selectedTiles.last!, toIndex: tilePosition!)) {
            // We have an accessible tile.
            // So, check to see if tile has been selected.
            let selectedTilesPosition = selectedTiles.firstIndex(of: tilePosition!)
            if (selectedTilesPosition != nil) {
              // The tile has already been selected.
              // If it's the same tile, nothing happens.
              // But, if it's the previous tile, need to backtrack.
              if selectedTiles.count > 1 && selectedTilesPosition == selectedTiles.count - 2 {
                // And it's the most recent, so backtrack.
                boardViewController.deselectTile(tileIndex: selectedTiles.last!)
                selectedTiles.remove(at: selectedTiles.count - 1)
              }
            } else {
              // Otherwise, select the tile.
              selectedTiles.append(tilePosition!)
              boardViewController.selectTile(tileIndex: tilePosition!)
            }
          }
        }
      }
      
    case .ended, .cancelled:
      // Check to see if current trie node is a word.
      let wordAttempt = stringFromSelectedTiles()
      if wordAttempt.contains("!") {
        // Internally "qu" is ! and as there's no "q", this covers qu and q.
        processWord(word: wordAttempt.replacingOccurrences(of: "!", with: "q"))
      }
      processWord(word: wordAttempt)

      
      // Clean up the view by deselecting tiles.
      for index in selectedTiles {
        boardViewController.deselectTile(tileIndex: index)
      }
      // Clean selected tiles memory.
      selectedTiles.removeAll()
            
    default:
      break
    }
  }

  
  
  @objc func didTapOnTime(_ sender: UITapGestureRecognizer) {
    guard delegate!.currentGame() != nil else { return }
    // Stopwatch tap only works for controlling a gamme.
    // Does not create a new game, etc.
    
    if (delegate!.currentGame()!.viable) {
      if (gameInProgess) {
        pauseGameMain(animated: true)
      } else {
        resumeGameMain()
      }
    } else {
      // Game is over
      endGameDisplay()
    }
  }
  
  
  @objc func didTapOnPlayPause(_ sender: UITapGestureRecognizer) {
    if uiData.impact { UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.5) }
    if gameInProgess {
      pauseGameMain(animated: true)
    } else if (delegate!.currentGame() != nil && delegate!.currentGame()!.viable) {
        resumeGameMain()
    } else {
      newGameMain()
    }
  }
  
  
  @objc func longPressingStop() {
    displayLinkTwoTimeElapsed += displayLinkTwo!.targetTimestamp - displayLinkTwo!.timestamp
  }
  
  
  @objc func didLongPressStop(_ sender: UILongPressGestureRecognizer) {
    
    switch sender.state {
     
    case .began:
      if uiData.impact { UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 0.75) }
      
      displayLinkTwo = CADisplayLink(target: self, selector: #selector(longPressingStop))
      displayLinkTwo!.add(to: .current, forMode: .common)
      playButtonsViewController.animateHighlight()
      
    case .changed:
      break
      
    case .ended, .cancelled:
      displayLinkTwo?.invalidate()
      playButtonsViewController.removeHighlight()
      if (displayLinkTwoTimeElapsed > 0.25) {
        endGameMain(fresh: true)
        playButtonsViewController.stopRemoveGesture(gesture: stopGR!)
      }
      displayLinkTwoTimeElapsed = 0
      
    default:
      break
    }
  }
  
  
  @objc func didLongPressBoard(_ sender: UILongPressGestureRecognizer) {
    
    switch sender.state {
      
    case .began:
      finalWordsViewController!.view.layer.opacity = 0
      boardViewController.setOpacity(to: 1)
    case .ended, .cancelled:
      finalWordsViewController!.view.layer.opacity = 1
      boardViewController.setOpacity(to: 0.25)
    default:
      break
    }
  }
}

// MARK: Timer functions.
extension GameCardViewController {
  
  @objc func Counting() {
    // As the timer for counting is tied to the refresh rate, updating the stopwatch is
    // done by calculating how much time has passed.
    let estimate = (displayLinkOne!.targetTimestamp - displayLinkOne!.timestamp)
    let usedPercent = estimate/(Double(delegate!.currentSettings().time))
    
    displayLinkOneTimeElapsed += estimate
    delegate!.currentGame()!.timeUsedPercent += usedPercent
    stopwatchViewController.incrementHandBy(percent: usedPercent)
    if (delegate!.currentGame()!.timeUsedPercent >= 1) {
      endGameMain(fresh: true)
    }
  }
  
}
