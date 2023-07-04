//
//  FoundWordsViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/29.
//

import UIKit

class FoundWordsViewController: UIViewController {
  
  private let wordViewWidth: CGFloat
  private let wordViewHeight: CGFloat
  private let wordViewSize: CGSize
  private let fontSize: CGFloat
  private let foundWordView: FoundWordView
  
  init(viewData vD: CardViewData) {
    
    wordViewWidth = vD.width - ((4 * vD.gameBoardPadding()) + (1.5 * vD.stopWatchSize()))
    wordViewHeight = vD.stopWatchSize()
    
    wordViewSize = CGSize(width: wordViewWidth, height: wordViewHeight)
    fontSize = wordViewSize.height * 0.15
    
    foundWordView = FoundWordView(listDimensions: CGSize(width: wordViewWidth - 2 * vD.tilePadding(), height: wordViewHeight - 2 * vD.tilePadding()), rowHieght: fontSize)
    
    super.init(nibName: nil, bundle: nil)
    
    self.view.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize())
    foundWordView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize())
    foundWordView.frame.origin = CGPoint(x: vD.tilePadding(), y: vD.tilePadding())
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(foundWordView)
    foundWordView.layer.borderColor = UIColor.black.cgColor
    foundWordView.layer.borderWidth = 1
    foundWordView.backgroundColor = UIColor.darkGray
    
    self.view.layer.backgroundColor = UIColor.darkGray.cgColor
    foundWordView.layer.backgroundColor = UIColor.lightGray.cgColor
  }
  
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.frame.size = wordViewSize
  }
  
  
  func update(word: String) {
    foundWordView.updateAndScroll(word: word)
  }
  
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
