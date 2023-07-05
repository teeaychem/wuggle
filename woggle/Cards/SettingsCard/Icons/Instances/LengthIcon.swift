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
    
    test()
  }
  
  
  override func updateIcon(value v: String) {
  }
  
  func test() {
    let letterLayer = CAShapeLayer()
    let characterLayers = getStringLayers(text: "6", font: UIFont(name: uiFontName, size: 25)!)
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
