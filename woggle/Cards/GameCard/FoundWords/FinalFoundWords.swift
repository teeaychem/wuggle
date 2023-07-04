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
  
  init(viewData vD: CardViewData) {
    
    // TODO: Fix this
    wordViewWidth = (vD.gameBoardSize() * 0.85 - (3 * vD.tilePadding())) * 0.5
    wordViewHeight = vD.gameBoardSize() * 0.85 - (2 * vD.tilePadding())
    
    wordViewSize = CGSize(width: wordViewWidth, height: wordViewHeight)
    fontSize = wordViewSize.height * 0.05
    
    foundWordView = FoundWordView(listDimensions: CGSize(width: wordViewWidth, height: wordViewHeight), rowHieght: fontSize)
    foundWordView.frame.origin = CGPoint(x: vD.tilePadding(), y: vD.tilePadding())
    
    
    noseeWordView = FoundWordView(listDimensions: CGSize(width: wordViewWidth, height: wordViewHeight), rowHieght: fontSize)
    noseeWordView.frame.origin = CGPoint(x: vD.tilePadding() * 2 + wordViewWidth, y: vD.tilePadding())
    
    foundWordView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize())
    noseeWordView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize())
    foundWordView.backgroundColor = UIColor.lightGray
    noseeWordView.backgroundColor = UIColor.lightGray
    
    super.init(nibName: nil, bundle: nil)
    
    view.backgroundColor = UIColor.darkGray
    view.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize())
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(foundWordView)
    view.addSubview(noseeWordView)
  }
  
  
  func addWordsAsFound(words: [String]) {
    let sorted = words.sorted()
    
    for word in sorted {
      foundWordView.updateAndScroll(word: word)
    }
  }
  
  func addWordsAsNosee(words: Set<String>) {
    let sorted = words.sorted()
    
    for word in sorted {
      noseeWordView.updateAndScroll(word: word)
    }
  }
}
