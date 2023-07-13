//
//  LexiconIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit


class LexiconIcon: IconView {
  
  private let letterLayer = CAShapeLayer()
  private let bookFrontLayer = CAShapeLayer()
  private let bookMiddleLayer = CAShapeLayer()
  private let bookBackLayer = CAShapeLayer()
  
  private let coverWidth: CGFloat
    
  init(viewData vD: UIData) {
    
    coverWidth = vD.squareIconSize.width * 0.7
    
    bookFrontLayer.fillColor = vD.colourM.cgColor
    bookMiddleLayer.fillColor = vD.colourL.cgColor
    bookBackLayer.fillColor = vD.colourM.cgColor
    letterLayer.fillColor = vD.colourL.cgColor
    
    super.init(size: vD.squareIconSize, viewData: vD)
    
    layer.addSublayer(bookBackLayer)
    layer.addSublayer(bookMiddleLayer)
    layer.addSublayer(bookFrontLayer)
    layer.addSublayer(letterLayer)
    
    addBook()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateIcon(value v: Int16) {
    switch v {
    case 0:
      addLetter(letter: "C")
    case 1:
      addLetter(letter: "O")
    case 2:
      addLetter(letter: "A")
    case 3:
      addLetter(letter: "B")
    case 4:
      addLetter(letter: "S")
    default:
      return
    }
  }
  
  
  private func addBook() {
    // Overlap three square to create something which looks bookish
    let bookFrontPath = UIBezierPath(
      roundedRect: CGRect(
        origin: CGPoint(x: 0, y: 0),
        size: CGSize(width: coverWidth, height: coverWidth)),
      cornerRadius: radius)
    
    bookFrontLayer.path = bookFrontPath.cgPath
    bookFrontLayer.frame = bookFrontPath.cgPath.boundingBox
    bookFrontLayer.frame.origin = CGPoint(x: indent, y: size.height - (coverWidth + indent))

    bookFrontLayer.lineWidth = 0.5
    bookFrontLayer.strokeColor = viewData.iconBorderColour.cgColor
    
    let bookMiddlePath = UIBezierPath(
      roundedRect: CGRect(
        origin: CGPoint(x: frame.width - (coverWidth + indent * 1.5), y: indent * 1.5),
        size: CGSize(width: coverWidth, height: coverWidth)),
      cornerRadius: radius)
    
    bookMiddleLayer.path = bookMiddlePath.cgPath
    
    let bookBackPath = UIBezierPath(
      roundedRect: CGRect(
        origin: CGPoint(x: frame.width - (coverWidth + indent), y: indent),
        size: CGSize(width: coverWidth, height: coverWidth)),
      cornerRadius: radius)
    
    bookBackLayer.path = bookBackPath.cgPath
    bookBackLayer.lineWidth = 0.5
    bookBackLayer.strokeColor = viewData.iconBorderColour.cgColor
  }
  
  
  private func addLetter(letter: String) {
    
    letterLayer.path = getStringPaths(text: letter, font: UIFont(name: uiFontName, size: getFontFor(height: size.height * 0.9))!).first!
    letterLayer.bounds = letterLayer.path!.boundingBox
    
    letterLayer.frame.origin = CGPoint(x: bookFrontLayer.frame.minX +  (coverWidth - letterLayer.frame.width) * 0.5, y: bookFrontLayer.frame.minY + (coverWidth - letterLayer.frame.height) * 0.5)
  }
  
}
