//
//  LexiconIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit


class LexiconIcon: IconView {
    
  override init(size s: CGFloat) {
    
    super.init(size: s)
    
    addBook()
    updateIcon(value: "L")
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateIcon(value v: String) {
    addLetter(letter: "L")
  }
  
  
  private func addBook() {
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
  
  
  private func addLetter(letter: String) {
    
    let letterLayer = getStringLayers(text: letter, font: UIFont(name: uiFontName, size: getFontFor(height: size * 0.9))!).first!
    letterLayer.bounds = letterLayer.path!.boundingBox
    letterLayer.fillColor = UIColor.lightGray.cgColor
        
    letterLayer.frame.origin = CGPoint(x: indent + (size * 0.7 - letterLayer.bounds.width) * 0.5, y: size - (((size * 0.7 - letterLayer.bounds.height) * 0.5) + indent + letterLayer.bounds.height))
    
    layer.addSublayer(letterLayer)
  }
  
}
