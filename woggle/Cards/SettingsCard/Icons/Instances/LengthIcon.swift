//
//  LengthIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit


class LengthIcon: IconView {
  
  override init(size s: CGFloat) {
    
    super.init(size: s)
    
    test2()
  }
  
  
  override func updateIcon(value v: String) {
  }
  
  
  func test2() {
    
    let tile = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: size*0.1, y: size*0.1), size: CGSize(width: size*0.8, height: size*0.8)), cornerRadius: radius)
    
    let tileLayer = CAShapeLayer()
    tileLayer.path = tile.cgPath
    
    tileLayer.fillColor = UIColor.gray.cgColor
    tileLayer.strokeColor = UIColor.black.cgColor
    tileLayer.lineWidth = 0.5
    
    layer.addSublayer(tileLayer)
    
    let tileIndent: CGFloat = size * 0.1
    let tilePadding: CGFloat = size * 0.05
    let tileSize: CGFloat = size * 0.25
    
    let radius2 = size * 0.05
    
//    for i in 0..<3 {
//
//      let xPoint: CGFloat = tileIndent + (tileSize * CGFloat(i)) + (tilePadding * (CGFloat(i) + 1))
//
//      let tile4 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: xPoint, y: size - ((size * 0.1) + tileIndent + tilePadding * 2)), size: CGSize(width: tileSize, height: tileSize)), cornerRadius: radius)
//
//      let tileLayer4 = CAShapeLayer()
//      tileLayer4.path = tile4.cgPath
//      tileLayer4.fillColor = UIColor.lightGray.cgColor
//      tileLayer4.strokeColor = UIColor.black.cgColor
//      tileLayer4.lineWidth = 0.5
//
//      layer.addSublayer(tileLayer4)
//    }
    
//    for i in 2..<3 {
//
//      let xPoint: CGFloat = tileIndent + (tileSize * CGFloat(i)) + (tilePadding * (CGFloat(i) + 1))
//
//      let tile4 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: xPoint, y: size - ((size * 0.1) + tileIndent + tileSize + tilePadding * 3)), size: CGSize(width: tileSize, height: tileSize)), cornerRadius: radius)
//
//      let tileLayer4 = CAShapeLayer()
//      tileLayer4.path = tile4.cgPath
//      tileLayer4.fillColor = UIColor.lightGray.cgColor
//      tileLayer4.strokeColor = UIColor.black.cgColor
//      tileLayer4.lineWidth = 0.5
//
//      layer.addSublayer(tileLayer4)
//    }
    
//    for i in 3..<3 {
//
//      let xPoint: CGFloat = tileIndent + (tileSize * CGFloat(i)) + (tilePadding * (CGFloat(i) + 1))
//
//      let tile4 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: xPoint, y: size - ((size * 0.1) + tileIndent + tileSize * 2 + tilePadding * 3)), size: CGSize(width: tileSize, height: tileSize)), cornerRadius: radius)
//
//      let tileLayer4 = CAShapeLayer()
//      tileLayer4.path = tile4.cgPath
//      tileLayer4.fillColor = UIColor.lightGray.cgColor
//      tileLayer4.strokeColor = UIColor.black.cgColor
//      tileLayer4.lineWidth = 0.5
//
//      layer.addSublayer(tileLayer4)
//    }
    
    let tile2 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: size - (tileIndent + tilePadding + tileSize), y: size - (tileIndent + tilePadding + tileSize)), size: CGSize(width: tileSize, height: tileSize)), cornerRadius: radius2)

    let tileLayer2 = CAShapeLayer()
    tileLayer2.path = tile2.cgPath

    tileLayer2.fillColor = UIColor.lightGray.cgColor
    tileLayer2.strokeColor = UIColor.white.cgColor
    tileLayer2.lineWidth = 0.5
    
    layer.addSublayer(tileLayer2)
//
//    let tile2 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: tileIndent + tileSize + tilePadding * 2, y: tileIndent + tilePadding), size: CGSize(width: tileSize, height: tileSize)), cornerRadius: radius2)
//
//    let tileLayer2 = CAShapeLayer()
//    tileLayer2.path = tile2.cgPath
//
//    tileLayer2.fillColor = UIColor.lightGray.cgColor
//    tileLayer2.strokeColor = UIColor.black.cgColor
//    tileLayer2.lineWidth = 0.5
//
//    let tile3 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: tileIndent + tileSize * 2 + tilePadding * 3, y: tileIndent + tilePadding), size: CGSize(width: tileSize, height: tileSize)), cornerRadius: radius2)
//
//    let tileLayer3 = CAShapeLayer()
//    tileLayer3.path = tile3.cgPath
//
//    tileLayer3.fillColor = UIColor.lightGray.cgColor
//    tileLayer3.strokeColor = UIColor.black.cgColor
//    tileLayer3.lineWidth = 0.5
//
//    let tile4 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: tileIndent + tileSize * 3 + tilePadding * 4, y: tileIndent + tilePadding), size: CGSize(width: tileSize, height: tileSize)), cornerRadius: radius2)
//
//    let tileLayer4 = CAShapeLayer()
//    tileLayer4.path = tile4.cgPath
//
//    tileLayer4.fillColor = UIColor.lightGray.cgColor
//    tileLayer4.strokeColor = UIColor.black.cgColor
//    tileLayer4.lineWidth = 0.5
    
    
//    layer.addSublayer(tileLayer)
//    layer.addSublayer(tileLayer2)
//    layer.addSublayer(tileLayer3)
//    layer.addSublayer(tileLayer4)
    
    let letterLayer = CAShapeLayer()
    let characterLayers = getStringLayers(text: "5", font: UIFont(name: uiFontName, size: getFontFor(height: size * 0.8))!)
    for lay in characterLayers {
      print("AH")
      letterLayer.bounds = lay.path!.boundingBox
      lay.fillColor = UIColor.lightGray.cgColor
      letterLayer.addSublayer(lay)
    }
    letterLayer.frame.origin = CGPoint(x: indent * 2, y: indent * 2)
    
    let plusLayer = CAShapeLayer()
    let plusLayers = getStringLayers(text: "+", font: UIFont(name: uiFontName, size: getFontFor(height: size * 0.6))!)
    for lay in plusLayers {
      plusLayer.bounds = lay.path!.boundingBox
      lay.fillColor = UIColor.lightGray.cgColor
      plusLayer.addSublayer(lay)
    }
    plusLayer.frame.origin = CGPoint(x: letterLayer.bounds.width + plusLayer.bounds.width, y: indent * 2)
    
    layer.addSublayer(letterLayer)
    layer.addSublayer(plusLayer)
    
  }
  
  func test() {
    let letterLayer = CAShapeLayer()
    let characterLayers = getStringLayers(text: "6", font: UIFont(name: uiFontName, size: getFontFor(height: size))!)
    for lay in characterLayers {
      print("AH")
      letterLayer.bounds = lay.path!.boundingBox
      lay.fillColor = UIColor.lightGray.cgColor
      letterLayer.addSublayer(lay)
    }
    letterLayer.frame.origin = CGPoint(x: indent * 2.5, y: indent * 3.5)
    
    let plusLayer = CAShapeLayer()
    let plusLayers = getStringLayers(text: "+", font: UIFont(name: uiFontName, size: 20)!)
    for lay in plusLayers {
      plusLayer.bounds = lay.path!.boundingBox
      lay.fillColor = UIColor.gray.cgColor
      plusLayer.addSublayer(lay)
    }
    plusLayer.frame.origin = CGPoint(x: frame.width - indent * 2.5, y: indent * 1.75)
    

    
    let rulerLayer = CAShapeLayer()
    let rulerPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: indent, y: indent + size * 0.15), size: CGSize(width: size * 0.65, height: size * 0.65)), cornerRadius: radius)
    rulerLayer.path = rulerPath.cgPath
    rulerLayer.fillColor = UIColor.gray.cgColor
    rulerLayer.lineWidth = 0.5
    rulerLayer.strokeColor = UIColor.black.cgColor
    
    
    
    let tapeLayer = CAShapeLayer()
    let tapePath = UIBezierPath()
    tapePath.move(to: CGPoint(x: size * 0.6, y: size * 0.85))
    tapePath.addArc(withCenter: CGPoint(x: size * 0.85, y: size * 0.8), radius: size * 0.05, startAngle: Double.pi * 0.5, endAngle: 0, clockwise: false)
    tapePath.addLine(to: CGPoint(x: size * 0.9, y: size * 0.775))

    tapeLayer.path = tapePath.cgPath
    tapeLayer.lineCap = .round
    tapeLayer.lineWidth = 4
    tapeLayer.strokeColor = UIColor.gray.cgColor
    tapeLayer.fillColor = UIColor.clear.cgColor
    
    layer.addSublayer(tapeLayer)
    layer.addSublayer(rulerLayer)
    layer.addSublayer(letterLayer)
    layer.addSublayer(plusLayer)
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
