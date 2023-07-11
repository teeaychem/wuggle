//
//  FinalFoundWords.swift
//  woggle
//
//  Created by sparkes on 2023/07/03.
//

import UIKit

class FinalFoundWordsViewController: UIViewController {
  
  private let wordViewWidth: CGFloat
  private let wordViewHeight: CGFloat
  private let wordViewSize: CGSize
  private let fontSize: CGFloat
  private let foundWordView: FoundWordView
  private let noseeWordView: FoundWordView
  
  init(viewData vD: ViewData) {
    
    // TODO: Fix this
    wordViewWidth = (vD.gameBoardSize * 0.85 - (3 * vD.tilePadding)) * 0.5
    wordViewHeight = vD.gameBoardSize * 0.85 - (2 * vD.tilePadding)
    
    wordViewSize = CGSize(width: wordViewWidth, height: wordViewHeight)
    fontSize = vD.stopWatchSize * 0.2
    
    foundWordView = FoundWordView(listDimensions: CGSize(width: wordViewWidth, height: wordViewHeight), rowHieght: fontSize)
    foundWordView.frame.origin = CGPoint(x: vD.tilePadding, y: vD.tilePadding)
    
    
    noseeWordView = FoundWordView(listDimensions: CGSize(width: wordViewWidth, height: wordViewHeight), rowHieght: fontSize)
    noseeWordView.frame.origin = CGPoint(x: vD.tilePadding * 2 + wordViewWidth, y: vD.tilePadding)
    
    foundWordView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize)
    noseeWordView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize)
    foundWordView.backgroundColor = vD.colourL
    noseeWordView.backgroundColor = vD.colourL
    
    super.init(nibName: nil, bundle: nil)
    
    
    view.backgroundColor = vD.colourD
    view.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(foundWordView)
    view.addSubview(noseeWordView)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame.size = CGSize(width: wordViewWidth * 2.075, height: wordViewHeight * 1.025)
  }
  
  
  func addWordsAsFound(words: [String]) {
    let sorted = words.sorted()
    
    for word in sorted {
      foundWordView.updateAndScroll(word: word)
    }
  }
  
  func addWordsAsNosee(words: [String]) {
    
    for word in words {
      noseeWordView.updateAndScroll(word: word)
    }
  }
  
  func addNoseeWordsDiff(noseeWords: [String], seeWords: [String]) {
    // Differentiate nosee from see words.
    // Sorts both nosee and see, then works through nosee.
    // As both sets are sorted, we'll for sure get to the ith seeSorted in nosee
    // before the ith + 1.
    // However, need an extra element to ensure seeIndex doesn't go out of range.
    let seeSorted = (seeWords + ["Z!"]).sorted()
    
    var seeIndex = 0
    
    for seeWord in noseeWords {
      if (seeWord == seeSorted[seeIndex]) {
        seeIndex += 1
        // TODO: Shade
        noseeWordView.updateNoScroll(word: seeWord)
      } else {
        noseeWordView.updateNoScroll(word: seeWord)
      }
    }
  }

}
