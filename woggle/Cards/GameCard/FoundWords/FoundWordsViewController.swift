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
  private let foundWordView: FoundWordView
  
  init(viewData vD: CardViewData) {
    
    wordViewWidth = vD.foundWordViewWidth
    wordViewHeight = vD.stopWatchSize
    
    foundWordView = FoundWordView(listDimensions: CGSize(width: wordViewWidth - 2 * vD.tilePadding, height: wordViewHeight - 2 * vD.tilePadding), rowHieght: wordViewHeight * 0.2)
    
    super.init(nibName: nil, bundle: nil)
    
    self.view.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize)
    foundWordView.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize)
    foundWordView.frame.origin = CGPoint(x: vD.tilePadding, y: vD.tilePadding)
    
    foundWordView.backgroundColor = vD.colourD
    self.view.layer.backgroundColor = vD.colourD.cgColor
    foundWordView.layer.backgroundColor = vD.colourL.cgColor

  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(foundWordView)
    foundWordView.layer.borderColor = UIColor.black.cgColor
    foundWordView.layer.borderWidth = 1
  }
  
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.frame.size = CGSize(width: wordViewWidth, height: wordViewHeight)
  }
  
  
  func update(word: String) {
    foundWordView.updateAndScroll(word: word)
  }
  
  
  func clear() {
    foundWordView.clearWords()
  }
  
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
