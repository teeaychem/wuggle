//
//  PlayButtonsViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/28.
//

import UIKit

class PlayButtonsViewController: UIViewController {
  
  private let size: CGSize
  private let playButtonsView: PlayButtonsView
  
  
  init(viewData vD: CardViewData) {
    
    size = CGSize(width: vD.stopWatchSize() * 0.5, height: vD.stopWatchSize())
    playButtonsView = PlayButtonsView(size: size)
   
    super.init(nibName: nil, bundle: nil)
    
    view.layer.cornerRadius = getCornerRadius(width: vD.width)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    self.view.addSubview(playButtonsView)
    playButtonsView.AddStopIcon()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame.size = size
    view.backgroundColor = UIColor.darkGray
  }
  
  
}
