//
//  TileIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit

class TileIcon: IconView {
        
  private let textLayer = CAShapeLayer()
  private let tileLayer = CAShapeLayer()
  private let letterLayer = CAShapeLayer()
  
  init(uiData uiD: UIData) {
    
    tileLayer.fillColor = uiD.colourM.cgColor
    
    letterLayer.fillColor = uiD.colourL.cgColor
    textLayer.fillColor = uiD.colourL.cgColor
    
    super.init(size: uiD.squareIconSize, uiData: uiD)

    addTile()
    addSquare()
    
    layer.addSublayer(letterLayer)
    layer.addSublayer(textLayer)
  }
    
  
  
  override func updateIcon(value v: Int16) {
    addText(text: String(v))
  }
  
  
  private func addTile() {
    let tile = UIBezierPath(
      roundedRect: CGRect(
        origin: CGPoint(x: size.width * 0.1, y: size.height * 0.1),
        size: CGSize(width: size.width * 0.8, height: size.height * 0.8)),
      cornerRadius: radius)
    
    tileLayer.path = tile.cgPath
    tileLayer.strokeColor = uiData.iconBorderColour.cgColor
    tileLayer.lineWidth = 0.5
    
    layer.addSublayer(tileLayer)
  }
  
  
  private func addSquare() {
    
    let tileFont = UIFont(name: uiFontName, size: size.height * 0.5)!
    
    letterLayer.path = getStringPaths(text: "²", font: tileFont).first
    letterLayer.bounds = letterLayer.path!.boundingBox
    letterLayer.frame.origin = CGPoint(x: frame.width - (letterLayer.bounds.width + indent * 1.5), y: indent * 1.5)
  }
  
  
  private func addText(text t: String) {
    
    textLayer.path = getStringPaths(text: t, font: UIFont(name: uiFontName, size: size.height * 0.8)!).first
    textLayer.bounds = textLayer.path!.boundingBox
    textLayer.frame.origin = CGPoint(x: indent * 1.5, y: frame.height - (textLayer.bounds.height + indent * 1.5))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

