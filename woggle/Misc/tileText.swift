//
//  tileText.swift
//  moreWaggle
//
//  Created by sparkes on 2023/06/22.
//

import UIKit
import CoreText


func getStringLayers(text: String, font: UIFont) -> [CAShapeLayer] {
  // This works by getting the glyphs for each character in the string.
  // So, it does not contain any information about the x/y origin of the character in the string.
  
  var uniChars = [UniChar](text.utf16)
  var glyphs = [CGGlyph](repeating: 0, count: uniChars.count)
  let foundGlyphs = CTFontGetGlyphsForCharacters(font, &uniChars, &glyphs, uniChars.count)
  var textLayer: [CAShapeLayer] = []
  
  if foundGlyphs {
    for i in 0 ..< glyphs.count {
      let glyphPath = CTFontCreatePathForGlyph(font, glyphs[i], nil)!
      let path = UIBezierPath(cgPath: glyphPath)
      // fonts are drawn upside down, so we mirror over y then move down
      path.apply(CGAffineTransform(scaleX: 1, y: -1))
      path.apply(CGAffineTransform(translationX: 0, y: font.capHeight))
      
      let glyphLayer = CAShapeLayer()
      glyphLayer.path = path.cgPath
      glyphLayer.lineWidth = 1
      glyphLayer.strokeEnd = 0
      glyphLayer.fillColor = tileOutlineColour.cgColor
      glyphLayer.strokeColor = tileStrokeColour.cgColor
      
      textLayer.append(glyphLayer)
    }
  }
  return textLayer
}


func animateStringLayerAppear(layer: CAShapeLayer) {
  
  let end = CABasicAnimation(keyPath: "strokeEnd")
  end.fromValue = 0
  end.toValue = 1
  
  let fill = CABasicAnimation(keyPath: "opacity")
  fill.fromValue = 0
  fill.toValue = 1
  
  let col = CABasicAnimation(keyPath: "fillColor")
  col.fromValue = UIColor.clear.cgColor
  col.toValue = tileFillColour.cgColor
  
  CATransaction.begin()
  CATransaction.setAnimationDuration(tileAnimDuration)
  
  layer.add(end, forKey: end.keyPath)
  layer.add(fill, forKey: fill.keyPath)
  layer.add(col, forKey: col.keyPath)

  layer.strokeEnd = 1
  layer.opacity = 1
  layer.fillColor = tileFillColour.cgColor

  CATransaction.commit()
}


func animateStringLayerDisappear(layer: CAShapeLayer) {
  
  let end = CABasicAnimation(keyPath: "strokeEnd")
  end.fromValue = 1
  end.toValue = 0
  
  let fill = CABasicAnimation(keyPath: "opacity")
  fill.fromValue = 1
  fill.toValue = 0
  
  let col = CABasicAnimation(keyPath: "fillColor")
  col.fromValue = tileFillColour.cgColor
  col.toValue = UIColor.clear.cgColor
  
  CATransaction.begin()
  CATransaction.setAnimationDuration(tileAnimDuration)

  layer.add(end, forKey: "strokeEnd")
  layer.add(fill, forKey: "opacity")
  layer.add(col, forKey: "fillColor")
  
  layer.opacity = 0
  layer.strokeEnd = 0
  layer.fillColor = UIColor.clear.cgColor
  
  CATransaction.commit()
}



