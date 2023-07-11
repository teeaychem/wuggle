//
//  StatViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/10.
//

import UIKit


class StatViewController: UIViewController {
  
  // TODO: Instead of stat + board, I want to have just stat, and when this is selected, show a large board.
  // This way, the board should be large enough to easily see.
  // Half the size of the main board might work.
  // But, then there's a lot of empty space.
  // Alternatively, hold down on the stat and see the board.
  // This works, except I only have maybe half.
  // And, double line doesn't feel good.
  // Instead, for longest word, implement shrink to width.
  // So, heterogram.
  // Highest Points/length ratio.
  // Lowest points/length ratio.
  // Oh, I can double and add the date.
  // So, with these suggestions, I have 8 + date.
  // This, then, is the plan.
  
  let statDisplayName: String
  let statDisplayValue: String
  let statInternalName: String
  
  let nameLabel: UILabel
  let valueLabel: UILabel
  
  init(statID sID: String, viewData vD: ViewData) {
    
    statInternalName = sID
    statDisplayName = "Most points"
    statDisplayValue = "500"
    
    nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: vD.statSize.width, height: vD.statSize.height * 0.6))
    valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: vD.statSize.width, height: vD.statSize.height * 0.6))
    
    super.init(nibName: nil, bundle: nil)

    view.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize * 0.5)
    
    nameLabel.attributedText = NSMutableAttributedString(string: statDisplayName, attributes: vD.getSettingsTextAttribute(height: vD.statSize.height * 0.64, colour: vD.colourL.cgColor))
    
    
    valueLabel.attributedText = NSMutableAttributedString(string: statDisplayValue, attributes: vD.getSettingsTextAttribute(height: vD.statSize.height * 0.64, colour: vD.colourL.cgColor))
    valueLabel.textAlignment = .right
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(nameLabel)
    view.addSubview(valueLabel)
  }

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
