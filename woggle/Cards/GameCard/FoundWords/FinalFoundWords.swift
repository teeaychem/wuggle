//
//  FinalFoundWords.swift
//  woggle
//
//  Created by sparkes on 2023/07/03.
//

import UIKit

class FinalFoundWordsViewController: UIViewController {
  
  private let wordViewSize: CGSize
  private let fontSize: CGFloat
  private let foundWordView: FoundWordView
  
  init(viewData vD: UIData) {
  
    
    wordViewSize = CGSize(width: vD.gameBoardSize * 0.85 - (2 * vD.tilePadding), height: vD.gameBoardSize * 0.85 - (2 * vD.tilePadding))
    fontSize = vD.stopWatchSize * 0.2
    
    foundWordView = FoundWordView(viewData: vD, listDimensions: CGSize(width: wordViewSize.width, height: wordViewSize.height), rowHieght: fontSize)
    foundWordView.frame.origin = CGPoint(x: vD.tilePadding, y: vD.tilePadding)
    
    foundWordView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize)
    foundWordView.backgroundColor = vD.colourL
    foundWordView.layer.borderColor = vD.iconBorderColour.cgColor
    foundWordView.layer.borderWidth = 1
    
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
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame.size = CGSize(width: wordViewSize.width * 1.025, height: wordViewSize.height * 1.025)
  }


  
  func addNoseeWordsDiff(noseeWords: [String], seeWords: [String]) {
    // Differentiate nosee from see words.
    // Sorts both nosee and see, then works through nosee.
    // As both sets are sorted, we'll for sure get to the ith seeSorted in nosee
    // before the ith + 1.
    // However, need an extra element to ensure seeIndex doesn't go out of range.
//    let seeSorted = (seeWords + ["Z!"]).sorted()
    
    for noseeWord in noseeWords {
      foundWordView.updateNoScroll(word: noseeWord, found: false)
    }
    for seeWord in seeWords {
      foundWordView.maybeOverWrite(word: seeWord, found: true)
    }
  }

}
