//
//  LexiconIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit


class LexiconIcon: IconView {
  
  let bookHeight: Double
  let bookWidth: Double
  let bookSquish = Double(1.5)
  let bookEllipseAngle = Double.pi/8
  
  let lambdaStrokeWidth: CGFloat
  let bookStrokeWidth: CGFloat
  
  let bookColour = UIColor.gray.cgColor
  let lambdaColour = UIColor.lightGray.cgColor
  
  let bookBaseX: Double
  let bookBaseY: Double
  let bookBasePoint: CGPoint
    
  override init(size s: CGFloat) {
    
    bookHeight = Double(s*0.7)
    bookWidth = Double((bookHeight * 2)/3)
    
    lambdaStrokeWidth = CGFloat(bookHeight)/12
    bookStrokeWidth = CGFloat(bookHeight)/15
    
    bookBaseX = Double(s*0.38)
    bookBaseY = Double(s*0.96)

    bookBasePoint = CGPoint(x: bookBaseX, y: bookBaseY)
    
    super.init(size: s)
    
    backgroundColor = UIColor.clear
    addBook()
    addLetter(letter: "L")
//    updateIcon(value: gameConfig.getLexicon())
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateIcon(value v: String) {
  }
  
  
  func addBook() {
    // Overlap three square to create something which looks bookish
    
    let bookFrontLayer = CAShapeLayer()
    let bookFrontPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: indent, y: frame.height - (size * 0.7 + indent)), size: CGSize(width: size*0.7, height: size*0.7)), cornerRadius: radius)
    
    bookFrontLayer.path = bookFrontPath.cgPath
    bookFrontLayer.fillColor = UIColor.gray.cgColor
    bookFrontLayer.lineWidth = 0.5
    bookFrontLayer.strokeColor = UIColor.black.cgColor
    
    let bookMiddleLayer = CAShapeLayer()
    let bookMiddlePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: frame.width - (size * 0.7 + indent * 1.5), y: indent * 1.5), size: CGSize(width: size*0.7, height: size*0.7)), cornerRadius: radius)
    
    bookMiddleLayer.path = bookMiddlePath.cgPath
    bookMiddleLayer.fillColor = UIColor.lightGray.cgColor
    
    
    let bookBackLayer = CAShapeLayer()
    let bookBackPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: frame.width - (size * 0.7 + indent), y: indent), size: CGSize(width: size*0.7, height: size*0.7)), cornerRadius: radius)
    
    bookBackLayer.path = bookBackPath.cgPath
    bookBackLayer.fillColor = UIColor.gray.cgColor
    bookBackLayer.lineWidth = 0.5
    bookBackLayer.strokeColor = UIColor.black.cgColor

    layer.addSublayer(bookBackLayer)
    layer.addSublayer(bookMiddleLayer)
    layer.addSublayer(bookFrontLayer)
  }
  
  
  func addLetter(letter: String) {
    
    let letterLayer = CAShapeLayer()
    let characterLayers = getStringLayers(text: letter, font: UIFont(name: uiFontName, size: 25)!)
    for lay in characterLayers {
      print("AH")
      letterLayer.bounds = lay.path!.boundingBox
      lay.fillColor = UIColor.lightGray.cgColor
      lay.strokeColor = UIColor.lightGray.cgColor
      lay.lineWidth = 1
      letterLayer.addSublayer(lay)
    }
    letterLayer.frame.origin = CGPoint(x: indent + (size * 0.7 - letterLayer.bounds.width) * 0.5, y: size - (((size * 0.7 - letterLayer.bounds.height) * 0.5) + indent + letterLayer.bounds.height))
    
    layer.addSublayer(letterLayer)
  }
  

}


func getEllipsePoint(origin: CGPoint, radius: Double, squish: Double, theta: Double) -> CGPoint {
  // See the following link for details
  // https://math.stackexchange.com/questions/22064/calculating-a-point-that-lies-on-an-ellipse-given-an-angle/22067#22067
  
  let a = radius
  let b = radius/squish
  
  let ab = a * b
  
  let aSinTheta = a * sin(theta)
  let bCosTheta = b * cos(theta)
  
  let denom = sqrt((bCosTheta * bCosTheta) + (aSinTheta * aSinTheta))
  
  var xPos = ((ab * cos(theta)) / denom)
  var yPos = ((ab * sin(theta)) / denom)
  
  if !(Double.pi/2 < theta || theta < (Double.pi*2)/3) {
    xPos = -xPos
    yPos = -yPos
  }
  
  xPos = xPos + Double(origin.x)
  yPos = Double(origin.y) - yPos
  
  return CGPoint(x: xPos, y: yPos)
}
