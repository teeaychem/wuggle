//
//  tileText.swift
//  moreWaggle
//
//  Created by sparkes on 2023/06/22.
//

import UIKit
import CoreText


func getStringPaths(text: String, font: UIFont) -> [CGPath] {
  // This works by getting the glyphs for each character in the string.
  // So, it does not contain any information about the x/y origin of the character in the string.
  
  var uniChars = [UniChar](text.utf16)
  var glyphs = [CGGlyph](repeating: 0, count: uniChars.count)
  let foundGlyphs = CTFontGetGlyphsForCharacters(font, &uniChars, &glyphs, uniChars.count)
  var textLayer: [CGPath] = []
  
  if foundGlyphs {
    for i in 0 ..< glyphs.count {
      let glyphPath = CTFontCreatePathForGlyph(font, glyphs[i], nil)!
      let path = UIBezierPath(cgPath: glyphPath)
      // fonts are drawn upside down, so we mirror over y then move down
      path.apply(CGAffineTransform(scaleX: 1, y: -1))
      path.apply(CGAffineTransform(translationX: 0, y: font.capHeight))
            
      textLayer.append(path.cgPath)
    }
  }
  return textLayer
}






