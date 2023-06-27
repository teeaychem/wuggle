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
  let foundWordsView: FoundWordView
  var currentGameInstace: GameInstance?
  
  var selectedTiles = [Int16]()
  var rootTrie: TrieNode
  
  override init(viewData vD: CardViewData, settings s: Settings) {
    
    // set current true node as root
    rootTrie = s.getTrieRoot()
    
    // First, get a board to work with from settings.
    currentGameInstace = s.getOrMakeCurrentGame()
    
    // Constants to create and position views
    let gameBoardSizePercent = 0.95
    let gameBoardSize = vD.width * gameBoardSizePercent
    let boardPadding = vD.width * ((1 - gameBoardSizePercent)/2)
    let stopwatchSize = vD.height - ((3 * boardPadding) + gameBoardSize + vD.statusBarHeight)
    
    // Fix controllers for the current views
    boardViewController = GameboardViewController(boardSize: gameBoardSize, gameBoard: currentGameInstace!.board!)
    stopwatchViewController = StopwatchViewController(size: stopwatchSize)
    foundWordsView = FoundWordView(listDimensions: CGSize(width: (vD.width - ((3 * boardPadding) + stopwatchSize)), height: stopwatchSize))
    
    super.init(viewData: vD, settings: s)

    // Position views
    boardViewController.view.frame.origin = CGPoint(x: boardPadding, y: vD.height - (gameBoardSize + boardPadding))
    // TODO: Shrink this for status bar
    stopwatchViewController.view.frame.origin = CGPoint(x: boardPadding, y: boardPadding + vD.statusBarHeight)
    foundWordsView.frame.origin = CGPoint(x: ((2 * boardPadding) + stopwatchSize), y: (boardPadding + vD.statusBarHeight))
    
    // TODO: Set the initial board view
    boardViewController.gameboardView.displayTileViews()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.embed(stopwatchViewController, inView: self.view)
    self.view.addSubview(foundWordsView)
    
    // MARK: Testing things.
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let testWord = GameWord(context: context)
    testWord.value = "Test"
    
    foundWordsView.updateAndScroll(word: testWord)
    // TODO: board needs to be last in order for touch to work.
    self.embed(boardViewController, inView: self.view)
    
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    boardViewController.gameboardView.addGestureRecognizer(panGestureRecognizer)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    foundWordsView.updateAndScroll(word: wordObject)
  }
  
  @objc func didPan(_ sender: UIPanGestureRecognizer) {
    
    let tilePosition = boardViewController.basicTilePositionFromCGPoint(point: sender.location(in: boardViewController.gameboardView))
    
    switch sender.state {
    case .began:
      // On start, set up trieRoot.
      // And, if in a tile, set initial tile.
      if (tilePosition != nil) {
        boardViewController.selectTile(tileIndex: tilePosition!)
        selectedTiles.append(tilePosition!)
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
              selectedTiles.append(tilePosition!)
              boardViewController.selectTile(tileIndex: tilePosition!)
            }
          }
        }
      }
      // Check to see if tile, and update if new tile
      // On new tile, move to trie node if possible.
      // If previous tile, then move back trie node.
      
    case .ended, .cancelled:
      // Check to see if current trie node is a word.
      let wordAttempt = stringFromSelectedTiles()
      let endTrie = rootTrie.traceString(word: wordAttempt)
      if (endTrie != nil) {
        if (endTrie!.isWord) {
          processWord(word: wordAttempt)
        }
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
}
