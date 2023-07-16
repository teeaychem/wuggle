//
//  StatViewController.swift
//  wuggle
//
//  Created by sparkes on 2023/07/10.
//

import UIKit


class StatViewController: UIViewController {
  
  // Future: Board associated with stat on long press
  
  let statDisplayName: String
  let statSize: CGSize
  let uiData: UIData
  
  let nameLabel: UILabel
  let valueLabel: UILabel
  let dateLabel: UILabel
  let extraLabel: UILabel
  
  init(stat s: Stat, displayName dN: String, uiData uiD: UIData) {
    
    statDisplayName = dN
    statSize = uiD.statSize
    uiData = uiD
    
    nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: uiD.statSize.width, height: uiD.statSize.height * 0.6))
    valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: uiD.statSize.width, height: uiD.statSize.height * 0.6))
    dateLabel = UILabel(frame: CGRect(x: 0, y: uiD.statSize.height * 0.6, width: uiD.statSize.width, height: uiD.statSize.height * 0.4))
    extraLabel = UILabel(frame: CGRect(x: 0, y: uiD.statSize.height * 0.6, width: uiD.statSize.width, height: uiD.statSize.height * 0.4))
    
    super.init(nibName: nil, bundle: nil)
    
    valueLabel.textAlignment = .right
    extraLabel.textAlignment = .right


    view.layer.cornerRadius = getCornerRadius(width: uiD.gameBoardSize * 0.5)
    
    nameLabel.attributedText = NSMutableAttributedString(string: statDisplayName, attributes: uiD.getSettingsTextAttribute(height: uiD.statSize.height * 0.64, colour: uiD.colourL.cgColor))
    
    updateWith(stat: s)
    
  }
  
  
  func updateWith(stat: Stat) {
    valueLabel.attributedText = NSMutableAttributedString(string: stat.strVal!, attributes: uiData.getSettingsTextAttribute(height: uiData.statSize.height * 0.64, colour: uiData.colourL.cgColor))
    dateLabel.attributedText = NSMutableAttributedString(string: stat.date?.formatted(date: .abbreviated, time: .shortened).description ?? "", attributes: uiData.getSettingsTextAttribute(height: uiData.statSize.height * 0.44, colour: uiData.colourL.cgColor))
    extraLabel.attributedText = NSMutableAttributedString(string: stat.extraStr!, attributes: uiData.getSettingsTextAttribute(height: uiData.statSize.height * 0.44, colour: uiData.colourL.cgColor))
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.frame.size = statSize
    view.addSubview(nameLabel)
    view.addSubview(valueLabel)
    view.addSubview(dateLabel)
    view.addSubview(extraLabel)
    
    let sep = UIView(frame: CGRect(x: 0, y: view.frame.maxY, width: statSize.width, height: statSize.height * 0.05))
    sep.layer.backgroundColor = uiData.colourL.cgColor
    view.addSubview(sep)
  }

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
