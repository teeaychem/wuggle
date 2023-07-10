//
//  TileIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit

class TileIcon: IconView {
        
  private var textLayer: CAShapeLayer?
  
  override init(size s: CGSize) {
    
    super.init(size: s)

    addTile()
    addSquare()
    updateIcon(value: "8")
  }
  
  override func updateIcon(value v: String) {
    addText(text: v)
  }
  
  
  private func addTile() {
    let tile = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: size.width * 0.1, y: size.height * 0.1), size: CGSize(width: size.width * 0.8, height: size.height * 0.8)), cornerRadius: radius)
    
    let tileLayer = CAShapeLayer()
    tileLayer.path = tile.cgPath
    
    tileLayer.fillColor = UIColor.gray.cgColor
    tileLayer.strokeColor = UIColor.black.cgColor
    tileLayer.lineWidth = 0.5
    
    layer.addSublayer(tileLayer)
  }
  
  
  private func addSquare() {
    
    let tileFont = UIFont(name: uiFontName, size: size.height * 0.5)!
    
    let letterLayer = getStringLayers(text: "²", font: tileFont).first
    letterLayer!.bounds = letterLayer!.path!.boundingBox
    letterLayer?.frame.origin = CGPoint(x: frame.width - (letterLayer!.bounds.width + indent * 1.5), y: indent * 1.5)
    letterLayer?.fillColor = UIColor.lightGray.cgColor
    
    layer.addSublayer(letterLayer!)
  }
  
  
  private func addText(text t: String) {
    
    if (textLayer != nil) {
      textLayer!.removeFromSuperlayer()
    }

    let tileFont = UIFont(name: uiFontName, size: size.height * 0.8)!
    
    textLayer = getStringLayers(text: t, font: tileFont).first
    textLayer!.bounds = textLayer!.path!.boundingBox
    textLayer!.frame.origin = CGPoint(x: indent * 1.5, y: frame.height - (textLayer!.bounds.height + indent * 1.5))
    textLayer!.fillColor = UIColor.lightGray.cgColor
    layer.addSublayer(textLayer!)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

