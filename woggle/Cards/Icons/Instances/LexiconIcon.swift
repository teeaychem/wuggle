//
//  LexiconIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit


class LexiconIcon: IconView {
  
  let letterLayer = CAShapeLayer()
  
  let bookFrontLayer = CAShapeLayer()
  let bookMiddleLayer = CAShapeLayer()
  let bookBackLayer = CAShapeLayer()
  
  let coverWidth: CGFloat
    
  override init(size s: CGSize, viewData vD: ViewData) {
    
    coverWidth = s.width * 0.7
    
    bookFrontLayer.fillColor = vD.colourM.cgColor
    bookMiddleLayer.fillColor = vD.colourL.cgColor
    bookBackLayer.fillColor = vD.colourM.cgColor
    letterLayer.fillColor = vD.colourL.cgColor
    
    super.init(size: s, viewData: vD)
    
    layer.addSublayer(bookBackLayer)
    layer.addSublayer(bookMiddleLayer)
    layer.addSublayer(bookFrontLayer)
    layer.addSublayer(letterLayer)
    
    addBook()
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
    let bookFrontPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: coverWidth, height: coverWidth)), cornerRadius: radius)
    
    bookFrontLayer.path = bookFrontPath.cgPath
    bookFrontLayer.frame = bookFrontPath.cgPath.boundingBox
    bookFrontLayer.frame.origin = CGPoint(x: indent, y: size.height - (coverWidth + indent))

    bookFrontLayer.lineWidth = 0.5
    bookFrontLayer.strokeColor = UIColor.black.cgColor
    
    let bookMiddlePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: frame.width - (coverWidth + indent * 1.5), y: indent * 1.5), size: CGSize(width: coverWidth, height: coverWidth)), cornerRadius: radius)
    
    bookMiddleLayer.path = bookMiddlePath.cgPath
    
    let bookBackPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: frame.width - (coverWidth + indent), y: indent), size: CGSize(width: coverWidth, height: coverWidth)), cornerRadius: radius)
    
    bookBackLayer.path = bookBackPath.cgPath
    bookBackLayer.lineWidth = 0.5
    bookBackLayer.strokeColor = UIColor.black.cgColor
  }
  
  
  private func addLetter(letter: String) {
    
    letterLayer.path = getStringPaths(text: letter, font: UIFont(name: uiFontName, size: getFontFor(height: size.height * 0.9))!).first!
    letterLayer.bounds = letterLayer.path!.boundingBox

    
    letterLayer.frame.origin = CGPoint(x: bookFrontLayer.frame.minX +  (coverWidth - letterLayer.frame.width) * 0.5, y: bookFrontLayer.frame.minY + (coverWidth - letterLayer.frame.height) * 0.5)
  }
  
}
