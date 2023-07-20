//
//  FoundWordsViewController.swift
//  wuggle
//
//  Created by sparkes on 2023/06/29.
//

import UIKit

class FoundWordsViewController: UIViewController {
  
  private let wordViewWidth: CGFloat
  private let wordViewHeight: CGFloat
  private let foundWordView: FoundWordView
  
  init(uiData uiD: UIData) {
    
    wordViewWidth = uiD.foundWordViewWidth
    wordViewHeight = uiD.stopWatchSize
    
    foundWordView = FoundWordView(uiData: uiD, listDimensions: CGSize(width: wordViewWidth - 2 * uiD.tilePadding, height: wordViewHeight - 2 * uiD.tilePadding), rowHieght: wordViewHeight * 0.2)
    
    super.init(nibName: nil, bundle: nil)
    
    self.view.layer.cornerRadius = getCornerRadius(width: uiD.gameBoardSize)
    foundWordView.layer.cornerRadius = getCornerRadius(width: uiD.gameBoardSize)
    foundWordView.frame.origin = CGPoint(x: uiD.tilePadding, y: uiD.tilePadding)
    
    foundWordView.backgroundColor = uiD.colourD
    self.view.layer.backgroundColor = uiD.colourD.cgColor
    foundWordView.layer.backgroundColor = uiD.colourL.cgColor
    foundWordView.layer.borderColor = uiD.iconBorderColour.cgColor
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(foundWordView)
    
    foundWordView.layer.borderWidth = 1
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame.size = CGSize(width: wordViewWidth, height: wordViewHeight)
  }
    
  
  func update(word w: String, found f: Bool, animated a: Bool) {
    foundWordView.updateAndScroll(word: w, found: f, animated: a)
  }
  
  
  func clear() {
    foundWordView.clearWords()
  }
  
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
