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
    wordViewWidth = (vD.width - (3 * vD.gameBoardPadding())) * 0.5
    wordViewHeight = vD.gameBoardSize() * 0.9
    
    wordViewSize = CGSize(width: wordViewWidth, height: wordViewHeight)
    fontSize = wordViewSize.height * 0.15
    
    
//    background = UIView(frame: CGRect(origin: CGPoint(x: vD.gameBoardPadding() + vD.gameBoardSize() * 0.075, y: vD.height - (vD.gameBoardPadding() + vD.gameBoardSize() * 0.925)), size: CGSize(width: vD.gameBoardSize() * 0.85, height: vD.gameBoardSize() * 0.85)))
    
    
    
    
    foundWordView = FoundWordView(listDimensions: CGSize(width: wordViewWidth - 2 * vD.tilePadding(), height: wordViewHeight - 2 * vD.tilePadding()))
    noseeWordView = FoundWordView(listDimensions: CGSize(width: wordViewWidth - 2 * vD.tilePadding(), height: wordViewHeight - 2 * vD.tilePadding()))
    
    super.init(nibName: nil, bundle: nil)
    
    view.backgroundColor = UIColor.darkGray
    view.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.red
  }
  
  deinit {
    print("final goodbye")
  }
  
}
