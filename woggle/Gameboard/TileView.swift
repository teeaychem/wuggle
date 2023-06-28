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
  let tileFont: UIFont
  var angle = CGFloat(0)
  let size: CGFloat
  let tileFrame: CGRect
  
  
  init(position p: CGPoint, size s: CGFloat, boardSize bS: CGFloat, text t: String) {

    size = s
    tileFrame = CGRect(x: p.x, y: p.y, width: size, height: size)
    
    let fontSizeAdjust = (getFontPixelSize(fontSize: 12) * size) * 0.5
    
    tileFont = UIFont(name: tileFontName, size: fontSizeAdjust)!

    
    if (t == "!") {
      text = "Qu"
    } else {
      text = t.capitalized
    }
    
    super.init(frame: tileFrame)
    
    layer.cornerRadius = getCornerRadius(width: bS)
    
    letterLayers = getStringLayers(text: text, font: tileFont)
    
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
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func rotateToOrientation(orientation: String) {
    
    if orientation == "left" {
      tileRotateFromTo(rotation: -angle + CGFloat.pi/2, toAngle: CGFloat.pi/2)
    } else if orientation == "right" {
      tileRotateFromTo(rotation: -angle + -CGFloat.pi/2, toAngle: -CGFloat.pi/2)
    } else if orientation == "flip" {
      tileRotateFromTo(rotation: -angle + CGFloat.pi, toAngle: CGFloat.pi)
    } else {
      tileRotateFromTo(rotation: -angle, toAngle: 0)
    }
  }
  
  
  func tileRotateFromTo(rotation r: CGFloat, toAngle ta: CGFloat) {
    
    var ra = r.truncatingRemainder(dividingBy: .pi*2)
    if (ra < -.pi) {
      ra += .pi*2
    } else if ra > .pi {
      ra -= .pi*2
    }
    
    transform = transform.rotated(by: r)
    
    CATransaction.begin()
    CATransaction.setAnimationDuration(tileAnimDuration)
    let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotation.fromValue = angle
    rotation.byValue = ra
    rotation.duration = 0.5
    rotation.isCumulative = false
    rotation.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0.01, 0.5, 1.5)
    CATransaction.setCompletionBlock {
      self.layer.removeAllAnimations()
    }
    CATransaction.commit()
    
    layer.add(rotation, forKey: "rotationAnimation")
    angle = ta
  }
  
  
  func displayTile() {
    let borderWidth = size * 0.02
    layer.borderWidth = borderWidth
    layer.backgroundColor = tileBackgroundColour.cgColor
  }
  
  
  func displayLetter(animated: Bool) {
    
    for lay in letterLayers {
      lay.removeAllAnimations()
    }
    
    let borderWidth = size*0.02
    
    if animated {
//      let bgcl = CABasicAnimation(keyPath: "backgroundColor")
//      bgcl.fromValue = UIColor.clear.cgColor
//      bgcl.toValue = tileBackgroundColour.cgColor
//
//      CATransaction.begin()
//      CATransaction.setAnimationDuration(tileAnimDuration)
//      layer.backgroundColor = tileBackgroundColour.cgColor
//      layer.borderWidth = borderWidth
//      CATransaction.commit()
//
//      layer.add(bgcl, forKey: bgcl.keyPath)
      
      for lay in letterLayers {
        animateStringLayerAppear(layer: lay)
        lay.lineWidth = borderWidth
      }
    } else {
      
//      layer.backgroundColor = tileBackgroundColour.cgColor
//      layer.borderWidth = borderWidth
      
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
      
//      let col = CABasicAnimation(keyPath: "backgroundColor")
//      col.fromValue = tileBackgroundColour.cgColor
//      col.toValue = UIColor.clear.cgColor
//
//      CATransaction.begin()
//      CATransaction.setAnimationDuration(tileAnimDuration)
//      layer.backgroundColor = UIColor.clear.cgColor
//      layer.borderWidth = 0
//      CATransaction.commit()
//
//      layer.add(col, forKey: col.keyPath)
      
      for lay in letterLayers {
        animateStringLayerDisappear(layer: lay)
      }
    } else {
      
//      layer.backgroundColor = UIColor.clear.cgColor
//      layer.borderWidth = 0
      
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
