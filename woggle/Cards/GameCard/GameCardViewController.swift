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

class GameCardViewController: CardViewController {

  let boardViewController: GameboardViewController
  let stopwatchViewController: StopwatchViewController
  let playButtonsViewController: PlayButtonsViewController
  let foundWordsViewController: FoundWordsViewController
  var finalWordsViewController: FinalFoundWordsViewController?
  
  var watchGestureRecognizer: UITapGestureRecognizer?
  var boardPanGR: UIPanGestureRecognizer?
  var playPauseGR: UITapGestureRecognizer?
  var stopGR: UILongPressGestureRecognizer?

  var currentGameInstace: GameInstance?
  
  var displayLinkOne: CADisplayLink?
  var displayLinkTwo: CADisplayLink?
  var displayLinkOneTimeElapsed = Double(0)
  var displayLinkTwoTimeElapsed = Double(0)
  let gameTimeInterval = 0.05
  
  // MARK: Variables which depend on gameInstance.
  // Initialised to 0, and then updated with setVaribalesFromCurrentGameInstance
//  var timeUsedPerStep = Double(0)
  var timeUsedPercent = Double(0)
//  var stopWatchIncrementPercent = Double(0)
  
  var gameInProgess = false
    
  var selectedTiles = [Int16]()
  var rootTrie: TrieNode?
  
  override init(viewData vD: CardViewData, delegate d: CardStackDelegate) {
    
    // Use delegate to pull some general infomration.
    rootTrie = d.provideCurrentSettings().getTrieRoot()
    currentGameInstace = d.provideCurrentSettings().getOrMakeCurrentGame()
    
    // Constants to create and position views
    // TODO: Collect together reused terms
    
    // Fix controllers  for the current views
    boardViewController = GameboardViewController(boardSize: vD.gameBoardSize(), tileSqrtFloat: CGFloat(currentGameInstace!.settings!.tileSqrt), tilePadding: vD.tilePadding())
    
    stopwatchViewController = StopwatchViewController(viewData: vD)
    
    playButtonsViewController = PlayButtonsViewController(viewData: vD)
    foundWordsViewController = FoundWordsViewController(viewData: vD)
    
    super.init(viewData: vD, delegate: d)
    
    setVaribalesFromCurrentGameInstance()
    playButtonsViewController.paintPlayIcon()
    playButtonsViewController.paintStopIcon()
    
    // Position views
    boardViewController.view.frame.origin = CGPoint(x: vD.gameBoardPadding(), y: vD.height - (vD.gameBoardSize() + vD.gameBoardPadding()))
    stopwatchViewController.view.frame.origin = CGPoint(x: vD.gameBoardPadding(), y: vD.gameBoardPadding() + vD.statusBarHeight)
    playButtonsViewController.view.frame.origin = CGPoint(x: (2 * vD.gameBoardPadding() + vD.stopWatchSize()), y: (vD.gameBoardPadding() + vD.statusBarHeight))
    foundWordsViewController.view.frame.origin = CGPoint(x: ((3 * vD.gameBoardPadding()) + (1.5 * vD.stopWatchSize())), y: (vD.gameBoardPadding() + vD.statusBarHeight))
    
    // TODO: At the end of the init I want to get things up.
    boardViewController.createAllTileViews(board: currentGameInstace!.board!)
    
    // Add gesture recognisers
    boardPanGR = UIPanGestureRecognizer(target: self, action: #selector(didPanOnBoard(_:)))
    boardPanGR!.maximumNumberOfTouches = 1
    playPauseGR = UITapGestureRecognizer(target: self, action: #selector(didTapOnPlayPause(_:)))
    stopGR = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressStop(_:)))
    playButtonsViewController.playPauseAddGesture(gesture: playPauseGR!)
    playButtonsViewController.stopAddGesture(gesture: stopGR!)
    stopGR?.minimumPressDuration = 0.1
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // TODO: board needs to be last in order for touch to work.
    self.embed(boardViewController, inView: self.view)
    boardViewController.addGameboardView()
    self.embed(stopwatchViewController, inView: self.view)
    self.embed(playButtonsViewController, inView: self.view)
    self.embed(foundWordsViewController, inView: self.view)
    
    // TODO: Only add this when a game is in progress.
    
    watchGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnTime(_:)))
    stopwatchViewController.view.addGestureRecognizer(watchGestureRecognizer!)
    stopwatchViewController.paintSeconds()
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setVaribalesFromCurrentGameInstance() {
    guard currentGameInstace != nil else { print("No game instance"); return }
    
//    timeUsedPerStep = (currentGameInstace!.settings!.time / 60) * gameTimeInterval
    timeUsedPercent = currentGameInstace!.timeUsedPercent
//    stopWatchIncrementPercent = ((2 * Double.pi) / (currentGameInstace!.settings!.time * 60)) * gameTimeInterval
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
    let wordObject = GameWord(context: delegate!.provideCurrentSettings().returnContext())
    wordObject.value = w
    foundWordsViewController.update(word: wordObject)
  }

}


// MARK: Functions for starting, pausing, and ending a game
extension GameCardViewController {
  
  
  func newGameMain() {
    print("new game main")
    // Remove all the tiles from the previous game.
    boardViewController.removeAllTimeViews()
    // Get a new game.
    currentGameInstace = delegate?.provideCurrentSettings().setAndGetNewGame()
    // Make sure variables are good.
    setVaribalesFromCurrentGameInstance()
    // Make new tiles.
    boardViewController.createAllTileViews(board: currentGameInstace!.board!)
    // Fix stopwatch
    stopwatchViewController.resetHand()
    stopwatchViewController.view.addGestureRecognizer(watchGestureRecognizer!)
    // Fix the icons.
    playButtonsViewController.paintStopIcon()
    playButtonsViewController.stopAddGesture(gesture: stopGR!)
    playButtonsViewController.paintPlayIcon()
  }
  
  
  func resumeGameMain() {
    boardViewController.gameboardView.displayTileViews()
    displayLinkOne = CADisplayLink(target: self, selector: #selector(Counting))
    displayLinkOne!.add(to: .current, forMode: .common)
    boardViewController.addGestureRecognizer(recogniser: boardPanGR!)
    playButtonsViewController.paintPauseIcon()
    gameInProgess = true
  }
  
  
  func pauseGameMain() {
    displayLinkOne?.invalidate()
    boardViewController.gameboardView.hideTileViews()
    playButtonsViewController.paintPlayIcon()
    boardViewController.removeGestureRecognizer(recogniser: boardPanGR!)
    gameInProgess = false
  }
  
  
  func endGameMain() {
    displayLinkOne?.invalidate()
    playButtonsViewController.hideStopIcon()
    playButtonsViewController.paintNewGameIcon()
    boardViewController.removeGestureRecognizer(recogniser: boardPanGR!)
    stopwatchViewController.view.removeGestureRecognizer(watchGestureRecognizer!)
    gameInProgess = false
    timeUsedPercent = 1
    finalWordsViewController = FinalFoundWordsViewController(viewData: viewData)
    self.embed(finalWordsViewController!, inView: self.view)

  }
}


// MARK: GestureRecognisers
extension GameCardViewController {
  
  @objc func didPanOnBoard(_ sender: UIPanGestureRecognizer) {
    // TODO: Maybe update this with a custom recogniser.
    // Basically, extend pan to include initial touch.
    
    let tilePosition = boardViewController.basicTilePositionFromCGPoint(point: sender.location(in: boardViewController.gameboardView), tileSqrtFloat: CGFloat((delegate?.provideCurrentSettings().tileSqrt)!))
    
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
      if (endTrie != nil && endTrie!.isWord) {
        processWord(word: wordAttempt)
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
    if (timeUsedPercent > 1) {
      // Game is over
      endGameMain()
    } else {
      if (gameInProgess) {
        pauseGameMain()
      } else {
        resumeGameMain()
      }
    }
  }
  
  
  @objc func didTapOnPlayPause(_ sender: UITapGestureRecognizer) {
    if gameInProgess {
      pauseGameMain()
    } else {
      if (timeUsedPercent < 1) {
        resumeGameMain()
      } else {
        newGameMain()
      }
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
      if (displayLinkTwoTimeElapsed > 0.5) {
        endGameMain()
        playButtonsViewController.stopRemoveGesture(gesture: stopGR!)
      }
      displayLinkTwoTimeElapsed = 0
      
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
    let usedPercent = estimate/(delegate!.provideCurrentSettings().time * 60)
    displayLinkOneTimeElapsed += estimate
    timeUsedPercent += usedPercent
    stopwatchViewController.incrementHand(percent: usedPercent)

    if (timeUsedPercent > 1) {
      endGameMain()
    }
  }
  
}
