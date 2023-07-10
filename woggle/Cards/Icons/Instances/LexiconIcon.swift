//
//  LexiconIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit


class LexiconIcon: IconView {
  
  var letterLayer: CAShapeLayer?
  
  var bookFrontLayer: CAShapeLayer?
  let coverWidth: CGFloat
    
  override init(size s: CGSize) {
    
    coverWidth = s.width * 0.7
    
    super.init(size: s)
    
    addBook()
    updateIcon(value: "0")
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateIcon(value v: String) {
    switch v {
    case "0":
      addLetter(letter: "M")
    case "1":
      addLetter(letter: "A")
    case "2":
      addLetter(letter: "W")
    case "3":
      addLetter(letter: "B")
    case "4":
      addLetter(letter: "S")
    default:
      return
    }
  }
  
  
  private func addBook() {
    // Overlap three square to create something which looks bookish
    
    bookFrontLayer = CAShapeLayer()
    let bookFrontPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: coverWidth, height: coverWidth)), cornerRadius: radius)
    
    bookFrontLayer!.path = bookFrontPath.cgPath
    bookFrontLayer!.frame = bookFrontPath.cgPath.boundingBox
    bookFrontLayer!.frame.origin = CGPoint(x: indent, y: size.height - (coverWidth + indent))
    bookFrontLayer!.fillColor = UIColor.gray.cgColor
    bookFrontLayer!.lineWidth = 0.5
    bookFrontLayer!.strokeColor = UIColor.black.cgColor
    
    let bookMiddleLayer = CAShapeLayer()
    let bookMiddlePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: frame.width - (coverWidth + indent * 1.5), y: indent * 1.5), size: CGSize(width: coverWidth, height: coverWidth)), cornerRadius: radius)
    
    bookMiddleLayer.path = bookMiddlePath.cgPath
    bookMiddleLayer.fillColor = UIColor.lightGray.cgColor
    
    
    let bookBackLayer = CAShapeLayer()
    let bookBackPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: frame.width - (coverWidth + indent), y: indent), size: CGSize(width: coverWidth, height: coverWidth)), cornerRadius: radius)
    
    bookBackLayer.path = bookBackPath.cgPath
    bookBackLayer.fillColor = UIColor.gray.cgColor
    bookBackLayer.lineWidth = 0.5
    bookBackLayer.strokeColor = UIColor.black.cgColor

    layer.addSublayer(bookBackLayer)
    layer.addSublayer(bookMiddleLayer)
    layer.addSublayer(bookFrontLayer!)
  }
  
  
  private func addLetter(letter: String) {
    
    if letterLayer != nil {
      letterLayer!.removeFromSuperlayer()
    }
    
    letterLayer = getStringLayers(text: letter, font: UIFont(name: uiFontName, size: getFontFor(height: size.height * 0.9))!).first!
    letterLayer!.bounds = letterLayer!.path!.boundingBox
    letterLayer!.fillColor = UIColor.lightGray.cgColor
    
    letterLayer?.frame.origin = CGPoint(x: bookFrontLayer!.frame.minX +  (coverWidth - letterLayer!.frame.width) * 0.5, y: bookFrontLayer!.frame.minY + (coverWidth - letterLayer!.frame.height) * 0.5)
    
    layer.addSublayer(letterLayer!)
  }
  
}
