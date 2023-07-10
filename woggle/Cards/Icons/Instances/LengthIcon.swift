//
//  LengthIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit


class LengthIcon: IconView {
  
  private var numberLayer: CAShapeLayer?
  
  override init(size s: CGSize) {
    
    super.init(size: s)
    
    paintBackground()
    updateIcon(value: "4")
  }
  
  
  override func updateIcon(value v: String) {
    paintNumber(num: v)
  }
  
  
  private func paintBackground() {
    
    let boardPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: size.width*0.1, y: size.height*0.1), size: CGSize(width: size.width*0.8, height: size.height*0.8)), cornerRadius: radius)
    
    let boardLayer = CAShapeLayer()
    boardLayer.path = boardPath.cgPath
    
    boardLayer.fillColor = UIColor.gray.cgColor
    boardLayer.strokeColor = UIColor.black.cgColor
    boardLayer.lineWidth = 0.5
    
    
    
    let tileIndent: CGFloat = size.width * 0.1
    let tilePadding: CGFloat = size.width * 0.05
    let tileSize: CGFloat = size.width * 0.25
    
    let radius2 = size.width * 0.05
    
    let highlightedTilePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: size.width - (tileIndent + tilePadding + tileSize), y: size.height - (tileIndent + tilePadding + tileSize)), size: CGSize(width: tileSize, height: tileSize)), cornerRadius: radius2)

    let highlightedTileLayer = CAShapeLayer()
    highlightedTileLayer.path = highlightedTilePath.cgPath

    highlightedTileLayer.fillColor = UIColor.lightGray.cgColor
    highlightedTileLayer.strokeColor = UIColor.white.cgColor
    highlightedTileLayer.lineWidth = 0.5
    
    
    
    let plusLayer = getStringLayers(text: "+", font: UIFont(name: uiFontName, size: getFontFor(height: size.height * 0.55))!).first!
    plusLayer.bounds = plusLayer.path!.boundingBox
    plusLayer.fillColor = UIColor.lightGray.cgColor
    plusLayer.frame.origin = CGPoint(x: frame.width * 0.85 - (plusLayer.bounds.width), y: indent * 1.5)
    
    layer.addSublayer(boardLayer)
    layer.addSublayer(highlightedTileLayer)
    
    layer.addSublayer(plusLayer)
  }
  
  
  private func paintNumber(num: String) {
    
    if numberLayer != nil {
      numberLayer!.removeFromSuperlayer()
    }
    
    numberLayer = getStringLayers(text: num, font: UIFont(name: uiFontName, size: getFontFor(height: size.height * 0.9))!).first!
    numberLayer!.bounds = numberLayer!.path!.boundingBox
    numberLayer!.fillColor = UIColor.lightGray.cgColor
        
    numberLayer!.frame.origin = CGPoint(x: indent * 1.5, y: indent * 1.5)
    
    layer.addSublayer(numberLayer!)
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
