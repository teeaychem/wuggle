//
//  PlayButtonsViewController.swift
//  woggle
//
//  Created by sparkes on 2023/06/28.
//

import UIKit

class PlayButtonsViewController: UIViewController {
  
  private let playButtonsView: PlayButtonsView

  
  init(viewData vD: CardViewData) {
    

    playButtonsView = PlayButtonsView(viewData: vD)
   
    super.init(nibName: nil, bundle: nil)
    
    view.layer.cornerRadius = getCornerRadius(width: vD.width)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    self.view.addSubview(playButtonsView)
    playButtonsView.addStopIcon()
//    playButtonsView.addPlayIcon()
//    playButtonsView.addPauseIcon()
    playButtonsView.addNewGameIcon()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame.size = playButtonsView.frame.size
    view.backgroundColor = UIColor.darkGray
  }
  
  
}
