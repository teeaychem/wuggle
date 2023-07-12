//
//  GameCardViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//
// Displays a card with the gameview.
// Primary settings are given by the card stack controller.
// On first run, request current game instance from settings.
// Load the board from the gameInstance, populate found words, fix timer.

// TODO: Timer
// TODO: Found words

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
  var boardPanGR: UIPanGestureRecognizer?
  var playPauseGR: UITapGestureRecognizer?
  var stopGR: UILongPressGestureRecognizer?
  
  var displayLinkOne: CADisplayLink?
  var displayLinkTwo: CADisplayLink?
  var displayLinkOneTimeElapsed = Double(0)
  var displayLinkTwoTimeElapsed = Double(0)
  
  var gameInProgess = false
    
  var selectedTiles = [Int16]()
  var rootTrie: TrieNode?
  
  override init(viewData vD: ViewData, delegate d: CardStackDelegate) {
    
    // Use delegate to pull some general infomration.
    rootTrie = d.currentSettings().getTrieRoot()
    
    // Icons
    combinedScoreViewC = CombinedScoreViewController(size: vD.statusBarSize, viewData: vD)
    
    // Fix controllers  for the current views
    boardViewController = GameboardViewController(boardSize: vD.gameBoardSize, viewData: vD, tilePadding: vD.tilePadding)
    stopwatchViewController = StopwatchViewController(viewData: vD)
    playButtonsViewController = PlayButtonsViewController(viewData: vD)
    foundWordsViewController = FoundWordsViewController(viewData: vD)
    
    super.init(viewData: vD, delegate: d)
    
    embed(combinedScoreViewC, inView: self.statusBarView, origin: CGPoint(x: 0, y: 0))
  }
  
  
  override func broughtToTop() {
    super.broughtToTop()
    
    // First set the views.
    self.embed(boardViewController, inView: self.cardView, origin: CGPoint(x: viewData.gameBoardPadding, y: viewData.height - (viewData.gameBoardSize + viewData.gameBoardPadding)))
    self.embed(stopwatchViewController, inView: self.cardView, origin: CGPoint(x: viewData.gameBoardPadding, y: viewData.gameBoardPadding + viewData.statusBarSize.height))
    self.embed(playButtonsViewController, inView: self.cardView, origin: CGPoint(x: (2 * viewData.gameBoardPadding + viewData.stopWatchSize), y: (viewData.gameBoardPadding + viewData.statusBarSize.height)))
    self.embed(foundWordsViewController, inView: self.cardView, origin: CGPoint(x: ((3 * viewData.gameBoardPadding) + (1.5 * viewData.stopWatchSize)), y: (viewData.gameBoardPadding + viewData.statusBarSize.height)))
    
    // TODO: Check these
    // Add gesture recognisers
    boardPanGR = UIPanGestureRecognizer(target: self, action: #selector(didPanOnBoard(_:)))
    boardPanGR!.maximumNumberOfTouches = 1
    playPauseGR = UITapGestureRecognizer(target: self, action: #selector(didTapOnPlayPause(_:)))
    stopGR = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressStop(_:)))
    playButtonsViewController.playPauseAddGesture(gesture: playPauseGR!)
    stopGR?.minimumPressDuration = 0.1
    watchGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnTime(_:)))
    stopwatchViewController.view.addGestureRecognizer(watchGestureRecognizer!)
    stopwatchViewController.paintSeconds()
    
    // TODO: Annotate
    if delegate!.currentGame() != nil {
      // Adjust things if there's a game.
      combinedScoreViewC.combinedUpdate(found: delegate!.currentGame()!.foundWordCount, score: delegate!.currentGame()!.pointsCount, percent: 0)
      
      boardViewController.createAllTileViews(board: delegate!.currentGame()!.board!)
      stopwatchViewController.setHandTo(percent: delegate!.currentGame()!.timeUsedPercent)
      for word in delegate!.currentGame()!.foundWordsList! {
        foundWordsViewController.update(word: word)
      }
      boardViewController.displayAllTiles()
      
      if delegate!.currentGame()!.viable {
        // If there's already a game, set things with stored data.
        playButtonsViewController.paintStopIcon()
        playButtonsViewController.stopAddGesture(gesture: stopGR!)
        playButtonsViewController.paintPlayIcon()
      } else {
        endGameMain()
      }
    } else {
      // Otherwise, let the user start a game.
      playButtonsViewController.paintNewGameIcon()
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
    
    super.shuffledToDeck()
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
    foundWordsViewController.update(word: w)
    if delegate?.currentGame()?.foundWordsList == nil {
      delegate?.currentGame()?.foundWordsList = [w]
    } else {
      if delegate!.currentGame()!.foundWordsList!.contains(w) {
        return
      } else {
        delegate!.currentGame()?.foundWordsList!.append(w)
        delegate!.currentGame()?.foundWordCount += 1
        delegate!.currentGame()?.pointsCount += Int16(getPoints(word: w))
        combinedScoreViewC.gameInstanceUpdate(instance: delegate!.currentGame()!)
        thinkAboutStats(word: w)
      }
    }
  }
  
  
  func thinkAboutStats(word w: String) {
    let wordLength = Double(w.count)
    if wordLength > delegate!.currentStats().topWordLength!.numVal {
      delegate!.currentStats().topWordLength!.numVal = wordLength
      delegate!.currentStats().topWordLength!.strVal = w.capitalized
      delegate!.currentStats().topWordLength!.extraStr = String(w.count) + " characters"
      delegate!.currentStats().topWordLength!.date = Date()
    }
    let wordPoints = Double(getPoints(word: w))
    if wordPoints > delegate!.currentStats().topWordPoints!.numVal {
      delegate!.currentStats().topWordPoints!.numVal = wordPoints
      delegate!.currentStats().topWordPoints!.strVal = w.capitalized
      delegate!.currentStats().topWordLength!.extraStr = String(wordPoints) + " points"
      delegate!.currentStats().topWordPoints!.date = Date()
    }
    let ratio = wordPoints/wordLength
    if ratio > delegate!.currentStats().topRatio!.numVal {
      delegate!.currentStats().topRatio!.numVal = wordPoints
      delegate!.currentStats().topRatio!.strVal = w.capitalized
      delegate!.currentStats().topRatio!.extraStr = String(ratio) + " points per character"
      delegate!.currentStats().topRatio!.date = Date()
    }
  }
  
  func thinkingAboutStats(game g: GameInstance) {
    let foundWordCount = Double(g.foundWordsList!.count)
    let pointsCollected = Double(g.pointsCount)
    let percentFound = foundWordCount / Double(g.allWordsList!.count)
    
    if foundWordCount > delegate!.currentStats().topWords!.numVal {
      delegate!.currentStats().topWords!.numVal = foundWordCount
      delegate!.currentStats().topWords!.strVal = String(Int(foundWordCount))
      delegate!.currentStats().topWords!.extraStr = "For " + String(Int(pointsCollected)) + " points"
      delegate!.currentStats().topWords!.date = Date()
    }
    
    if pointsCollected > delegate!.currentStats().topPoints!.numVal {
      delegate!.currentStats().topPoints!.numVal = pointsCollected
      delegate!.currentStats().topPoints!.strVal = String(Int(pointsCollected))
      delegate!.currentStats().topPoints!.extraStr = "In " + String(Int(foundWordCount)) + " words"
      delegate!.currentStats().topPoints!.date = Date()
    }
    
    if percentFound > delegate!.currentStats().topPercent!.numVal {
      delegate!.currentStats().topPercent!.numVal = percentFound
      delegate!.currentStats().topPercent!.strVal = String(Int(percentFound * 100))
      delegate!.currentStats().topPercent!.extraStr = String(Int(foundWordCount)) + " out of " + String(delegate!.currentGame()!.allWordsList!.count) + " words"
      delegate!.currentStats().topPercent!.date = Date()
      
      
    }
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}



// MARK: Starting, pausing, and ending a game
extension GameCardViewController {
  
  func newGameMain() {
    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    // Remove all the tiles from the previous game.
    boardViewController.removeAllTileViews()
    // Get a new game.
    delegate?.currentSettings().setNewGame()
    // Clear foundWords
    foundWordsViewController.clear()
    // Fix stopwatch
    stopwatchViewController.resetHand()
    boardViewController.createAllTileViews(board: delegate!.currentGame()!.board!)
        
    if (finalWordsViewController != nil) {
      self.unembed(finalWordsViewController!, inView: self.cardView)
      finalWordsViewController = nil
    }
    
    playButtonsViewController.playPauseRemoveGesture(gesture: playPauseGR!)
    
    displayLinkTwo = CADisplayLink(target: self, selector: #selector(newGameWait))
    displayLinkTwo!.add(to: .current, forMode: .common)
    
    // So, basically, as part of this function we load up a private managed context which runs on a different thread.
    // This then works on the settings file separately from the settings in use on the main thread.
    // Perform means that we don't wait around for what is requested.
    // Saving then merges the two contexts.
    
      let privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = self.delegate?.currentSettings().managedObjectContext
        return managedObjectContext
      }()
            
      let settingsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
      settingsFetchRequest.fetchLimit = 1
      if let result = try? privateManagedObjectContext.fetch(settingsFetchRequest) {
        let settings = result.first as! Settings
        privateManagedObjectContext.perform {
          settings.currentGame?.findPossibleWords()
          do {
            try privateManagedObjectContext.save()
          } catch {
            print("heck")
          }
        }
      }
  }
  
  
  @objc func newGameWait() {
       
    if displayLinkTwoTimeElapsed < 1 {
      
      displayLinkTwoTimeElapsed += displayLinkTwo!.targetTimestamp - displayLinkTwo!.timestamp
      
      playButtonsViewController.rotatePlayPauseIcon(percent: displayLinkTwoTimeElapsed)
      for tile in boardViewController.gameboardView.tiles.values {
        tile.partialDiplayTile(percent: displayLinkTwoTimeElapsed)
      }
    } else {
      
      displayLinkTwo?.invalidate()
      displayLinkTwoTimeElapsed = 0
      // Fix the icons.
      playButtonsViewController.paintStopIcon()
      playButtonsViewController.stopAddGesture(gesture: stopGR!)
      playButtonsViewController.paintPlayIcon()
      
      stopwatchViewController.view.addGestureRecognizer(watchGestureRecognizer!)
      playButtonsViewController.playPauseAddGesture(gesture: playPauseGR!)
      
      boardViewController.displayAllTiles()
    }
  }
  
  
  func resumeGameMain() {
    boardViewController.gameboardView.displayTileViews()
    displayLinkOne = CADisplayLink(target: self, selector: #selector(Counting))
    displayLinkOne!.add(to: .current, forMode: .common)
    boardViewController.removeAllGestureRecognizers()
    boardViewController.addGestureRecognizer(recogniser: boardPanGR!)
    playButtonsViewController.paintPauseIcon()
    gameInProgess = true
  }
  
  
  func pauseGameMain(animated a: Bool) {
    displayLinkOne?.invalidate()
    boardViewController.gameboardView.hideTileViews(animated: a)
    playButtonsViewController.paintPlayIcon()
    boardViewController.removeAllGestureRecognizers()
    gameInProgess = false
  }
  
  
  func endGameMain() {
    boardViewController.gameboardView.setOpacity(to: 0.25)
    // Cancel timer, pause and end game
    displayLinkOne?.invalidate()
    gameInProgess = false
    delegate!.currentGame()?.viable = false
    // Update buttons
    playButtonsViewController.hideStopIcon()
    playButtonsViewController.paintNewGameIcon()
    // Remove gestures
    boardViewController.removeGestureRecognizer(recogniser: boardPanGR!)
    stopwatchViewController.view.removeGestureRecognizer(watchGestureRecognizer!)
    // Display final words
    finalWordsViewController = FinalFoundWordsViewController(viewData: viewData)
    self.embed(finalWordsViewController!, inView: self.cardView, origin: CGPoint(x: viewData.gameBoardPadding + viewData.gameBoardSize * 0.075, y: viewData.height - viewData.gameBoardSize * 0.925 - viewData.gameBoardPadding))
    finalWordsViewController?.addWordsAsFound(words: delegate!.currentGame()!.foundWordsList!)
    finalWordsViewController?.addNoseeWordsDiff(noseeWords: (delegate!.currentGame()!.allWordsList!), seeWords: delegate!.currentGame()!.foundWordsList!)
    // Add gesture to see board.
    boardViewController.addGestureRecognizer(recogniser: UILongPressGestureRecognizer(target: self, action: #selector(didLongPressBoard)))
    
    thinkingAboutStats(game: delegate!.currentGame()!)
  }
}


// MARK: GestureRecognisers
extension GameCardViewController {
  
  
  @objc func didPanOnBoard(_ sender: UIPanGestureRecognizer) {
    // TODO: Maybe update this with a custom recogniser.
    // Basically, extend pan to include initial touch.
    
    let tilePosition = boardViewController.basicTilePositionFromCGPoint(point: sender.location(in: boardViewController.gameboardView), tileSqrtFloat: CGFloat((delegate?.currentSettings().tileSqrt)!))
    
    switch sender.state {
    case .began:
      // On start, set up trieRoot.
      // And, if in a tile, set initial tile.
      if (tilePosition != nil) {
        boardViewController.selectTile(tileIndex: tilePosition!)
        selectedTiles.append(tilePosition!)
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
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
      let endTrie = rootTrie!.traceString(word: wordAttempt)
      if (endTrie != nil && endTrie!.isWord && endTrie!.lexiconList![Int(delegate!.currentSettings().lexicon)]) {
        processWord(word: wordAttempt.replacingOccurrences(of: "!", with: "Qu"))
      }
      
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
      endGameMain()
    }
  }
  
  
  @objc func didTapOnPlayPause(_ sender: UITapGestureRecognizer) {
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
      displayLinkTwo = CADisplayLink(target: self, selector: #selector(longPressingStop))
      displayLinkTwo!.add(to: .current, forMode: .common)
      playButtonsViewController.animateHighlight()
      
    case .changed:
      break
      
    case .ended, .cancelled:
      displayLinkTwo?.invalidate()
      playButtonsViewController.removeHighlight()
      if (displayLinkTwoTimeElapsed > 0.125) {
        endGameMain()
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
      boardViewController.gameboardView.setOpacity(to: 1)
    case .ended, .cancelled:
      finalWordsViewController!.view.layer.opacity = 1
      boardViewController.gameboardView.setOpacity(to: 0.25)
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
    let usedPercent = estimate/(Double(delegate!.currentSettings().time) * 60)
    
    displayLinkOneTimeElapsed += estimate
    delegate!.currentGame()!.timeUsedPercent += usedPercent
    stopwatchViewController.incrementHandBy(percent: usedPercent)
    if (delegate!.currentGame()!.timeUsedPercent >= 1) {
      endGameMain()
    }
  }
  
}
