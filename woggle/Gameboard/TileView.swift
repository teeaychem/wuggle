//
//  TileView.swift
//  woggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit


class TileView: UIView {
  
  let text: String
  var letterLayers: [CAShapeLayer] = []
  let size: CGFloat
  let borderWidth: CGFloat
  let borderLayer = CAShapeLayer()
    
  init(position p: CGPoint, size s: CGFloat, boardSize bS: CGFloat, text t: String) {

    size = s
    borderWidth = s * 0.02

    
    if (t == "!") {
      text = "Qu"
    } else {
      text = t.capitalized
    }
    
    super.init(frame: CGRect(x: p.x, y: p.y, width: size, height: size))
    
    layer.cornerRadius = getCornerRadius(width: bS)
    
    letterLayers = getStringLayers(text: text, font: UIFont(name: tileFontName, size: getFontFor(height: size))!)
    
    var lastWidth = CGFloat(0)
    var maxHeight = CGFloat(0)
    
    for sublayer in letterLayers {
      
      sublayer.position.x = lastWidth
      let indent = sublayer.path!.boundingBox.minX + sublayer.path!.boundingBox.maxX
      lastWidth += CGFloat(indent)
      
      if sublayer.path!.boundingBox.height > maxHeight {
        maxHeight = sublayer.path!.boundingBox.height
      }
      layer.addSublayer(sublayer)
      sublayer.opacity = 0
    }
    
    let indent = (size - lastWidth)/2
    
    for sublayer in letterLayers {
      sublayer.position.x += indent
      sublayer.position.y = (size - maxHeight)/2
    }
    
    makeBorder()
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func makeBorder() {
    
    let borderPath = randomStartRoundedUIBeizerPath(width: frame.width, height: frame.height, cornerRadius: layer.cornerRadius)
    borderLayer.path = borderPath.cgPath
    borderLayer.lineWidth = 1
    borderLayer.strokeColor = UIColor.black.cgColor
    borderLayer.fillColor = UIColor.clear.cgColor
    
    layer.addSublayer(borderLayer)
    borderLayer.strokeStart = 0
    borderLayer.strokeEnd = 0
  }
  
  
  func displayTile() {
    borderLayer.strokeEnd = 1
    layer.backgroundColor = tileBackgroundColour.cgColor
  }
  
  
  func partialDiplayTile(percent: Double) {
    borderLayer.strokeEnd = percent * 1.5
  }
  
  
  
  func displayLetter(animated: Bool) {
    
    for lay in letterLayers {
      lay.removeAllAnimations()
    }
    
    if animated {
      for lay in letterLayers {
        animateStringLayerAppear(layer: lay)
        lay.lineWidth = borderWidth
      }
    } else {
      for lay in letterLayers {
        lay.opacity = 1
        lay.strokeEnd = 1
        lay.lineWidth = borderWidth
        lay.fillColor = tileFillColour.cgColor
      }
    }
  }
  
  
  func disappear(animated: Bool) {
    
    for lay in letterLayers {
      lay.removeAllAnimations()
    }
    
    if animated {
      for lay in letterLayers {
        animateStringLayerDisappear(layer: lay)
      }
    } else {
      
      for lay in letterLayers {
        lay.opacity = 0
        lay.strokeEnd = 0
        lay.fillColor = UIColor.clear.cgColor
      }
    }
  }
  
  
  func tileSelected() {
    for layer in letterLayers {
      layer.fillColor = tileSelectedColour.cgColor
    }
      layer.borderColor = tileSelectedColour.cgColor
  }
  
  
  func tileDeselected() {
    for layer in letterLayers {
      layer.fillColor = tileFillColour.cgColor
    }
      layer.borderColor = UIColor.black.cgColor
  }
  
  
  
}
