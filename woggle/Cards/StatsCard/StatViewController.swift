//
//  StatViewController.swift
//  woggle
//
//  Created by sparkes on 2023/07/10.
//

import UIKit


class StatViewController: UIViewController {
  
  // TODO: Board associated with stat on long press
  
  let statDisplayName: String
  let statSize: CGSize
  let viewData: ViewData
  
  let nameLabel: UILabel
  let valueLabel: UILabel
  let dateLabel: UILabel
  let extraLabel: UILabel
  
  init(stat s: Stat, displayName dN: String, viewData vD: ViewData) {
    
    statDisplayName = dN
    statSize = vD.statSize
    viewData = vD
    
    nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: vD.statSize.width, height: vD.statSize.height * 0.6))
    valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: vD.statSize.width, height: vD.statSize.height * 0.6))
    dateLabel = UILabel(frame: CGRect(x: 0, y: vD.statSize.height * 0.6, width: vD.statSize.width, height: vD.statSize.height * 0.4))
    extraLabel = UILabel(frame: CGRect(x: 0, y: vD.statSize.height * 0.6, width: vD.statSize.width, height: vD.statSize.height * 0.4))
    
    super.init(nibName: nil, bundle: nil)
    
    valueLabel.textAlignment = .right
    extraLabel.textAlignment = .right


    view.layer.cornerRadius = getCornerRadius(width: vD.gameBoardSize * 0.5)
    
    nameLabel.attributedText = NSMutableAttributedString(string: statDisplayName, attributes: vD.getSettingsTextAttribute(height: vD.statSize.height * 0.64, colour: vD.colourL.cgColor))
    
    updateWith(stat: s)
    
  }
  
  
  func updateWith(stat: Stat) {
    valueLabel.attributedText = NSMutableAttributedString(string: stat.strVal!, attributes: viewData.getSettingsTextAttribute(height: viewData.statSize.height * 0.64, colour: viewData.colourL.cgColor))
    dateLabel.attributedText = NSMutableAttributedString(string: stat.date?.formatted(date: .abbreviated, time: .shortened).description ?? "", attributes: viewData.getSettingsTextAttribute(height: viewData.statSize.height * 0.44, colour: viewData.colourL.cgColor))
    extraLabel.attributedText = NSMutableAttributedString(string: stat.extraStr!, attributes: viewData.getSettingsTextAttribute(height: viewData.statSize.height * 0.44, colour: viewData.colourL.cgColor))
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.frame.size = statSize
    view.addSubview(nameLabel)
    view.addSubview(valueLabel)
    view.addSubview(dateLabel)
    view.addSubview(extraLabel)
    
    let sep = UIView(frame: CGRect(x: 0, y: view.frame.maxY, width: statSize.width, height: statSize.height * 0.05))
    sep.layer.backgroundColor = viewData.colourL.cgColor
    view.addSubview(sep)
  }

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
