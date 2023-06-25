//
//  UIRelated.swift
//  moreWaggle
//
//  Created by sparkes on 2023/06/22.
//

import UIKit


let statusTextColour = UIColor.lightGray
let statusTextBackground = UIColor.gray

let gameCardColour = UIColor.black
let settingsCardColour = UIColor.darkGray
let statsCardColour = UIColor.gray

let regularText = UIColor.black
let reguardTextShaded = UIColor.darkGray

let gameCardIndent = UIColor.darkGray
let gameCardOutdent = UIColor.lightGray

let tileOutlineColour = UIColor.black
let tileStrokeColour = UIColor.darkGray
let tileFillColour = UIColor.gray
let tileSelectedColour = UIColor.white
let tileBackgroundColour = UIColor.lightGray

let boardBackgroundColour = UIColor.darkGray
let gameCardElementBackgroundColour = UIColor.gray

let interactiveStrokeColour = UIColor.black

let settingsMenuBackgroundColour = UIColor.lightGray
let settingsTextColour = UIColor.darkGray
let settingsTextSelectedColour = UIColor.lightGray

let tileAnimDuration = 0.5

let defaultAnimationDuration = 1.0


let gCardFontSize = CGFloat(12)
let tileFontName = "K2D-ExtraBold"
let uiFontName = "K2D-ExtraBold"
let textFontName = "K2D-Regular"
let italicFontName = "K2D-Italic"

let gCardFont = UIFont(name: uiFontName, size: gCardFontSize)!

func getFontPixelSize(fontSize: CGFloat) -> CGFloat {
  let fontLayer = getStringLayers(text: "M", font: gCardFont)
  let gCardFontPixelMultiplyer = 1 / (fontLayer[0].path?.boundingBox.width)!
  return gCardFontSize * gCardFontPixelMultiplyer
}
