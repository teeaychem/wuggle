//
//  TileIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit

class TileIcon: IconView {
        
  var textLayers = [CAShapeLayer]()
  
  
  override init(size s: CGFloat) {
    
    super.init(size: s)

    addTile()
    addText(text: "8²")
//    updateIcon(value: gameConfig.getTiles())
  }
  
  override func updateIcon(value v: String) {
    switch v {
    case "stock":
      addText(text: "t")
    case "deluxe":
      addText(text: "T")
    default:
      addText(text: "e")
    }
  }
  
  
  func addTile() {
    let tile = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: size*0.1, y: size*0.1), size: CGSize(width: size*0.8, height: size*0.8)), cornerRadius: radius)
    
    let tileLayer = CAShapeLayer()
    tileLayer.path = tile.cgPath
    
    tileLayer.fillColor = UIColor.gray.cgColor
    tileLayer.strokeColor = UIColor.black.cgColor
    tileLayer.lineWidth = 0.5
    
    layer.addSublayer(tileLayer)
  }
  
  
  func addText(text t: String) {
    
    for lay in textLayers {
      lay.removeFromSuperlayer()
    }
    textLayers.removeAll()
    
    let tileFont = UIFont(name: uiFontName, size: 25)!
    
    let letterLayers = getStringLayers(text: t, font: tileFont)
    
    for lay in letterLayers {
      
      lay.position.x = lay.position.x + size * 0.3
      lay.position.y = lay.position.y + 2 * indent
      lay.fillColor = UIColor.lightGray.cgColor
      lay.strokeColor = UIColor.lightGray.cgColor
      
      textLayers.append(lay)
      layer.addSublayer(lay)
    }
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

