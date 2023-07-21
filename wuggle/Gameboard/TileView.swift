//
//  TileView.swift
//  wuggle
//
//  Created by sparkes on 2023/06/24.
//

import UIKit


class TileView: UIView {
  
  let tileAnimDuration = 0.5
  let text: String
  var letterLayers: [CAShapeLayer] = []
  let size: CGFloat
  let borderWidth: CGFloat
  let borderLayer = CAShapeLayer()
  let letterOutlineColour: CGColor
  let tileBackgroundColor: CGColor
  let tileFillColour: CGColor
  let tileSelectedColour: CGColor
  let uiData: UIData
  var inUse = true

  init(position p: CGPoint, size s: CGFloat, boardSize bS: CGFloat, text t: String, uiData uiD: UIData) {

    size = s
    borderWidth = s * 0.02
    uiData = uiD
    
    letterOutlineColour = uiD.colourD.cgColor
    tileBackgroundColor = uiD.colourL.cgColor
    tileFillColour = uiD.colourM.cgColor
    tileSelectedColour = uiD.userInteractionColour.cgColor
    
    if (t == "!") {
      text = "Qu"
    } else {
      text = t.capitalized
    }
    
    super.init(frame: CGRect(x: p.x, y: p.y, width: size, height: size))
    
    layer.cornerRadius = getCornerRadius(width: bS)
    
    let paths = getStringPaths(text: text, font: UIFont(name: tileFontName, size: getFontFor(height: size))!)
    
    var lastWidth = CGFloat(0)
    var maxHeight = CGFloat(0)
  
    
    for path in paths {
    
      let letterLayer = CAShapeLayer()
      letterLayer.path = path
    
      letterLayer.position.x = lastWidth
      let indent = letterLayer.path!.boundingBox.minX + letterLayer.path!.boundingBox.maxX
      lastWidth += CGFloat(indent)
      
      if letterLayer.path!.boundingBox.height > maxHeight {
        maxHeight = letterLayer.path!.boundingBox.height
      }
      layer.addSublayer(letterLayer)
      letterLayer.opacity = 0
      letterLayer.strokeStart = 0
      letterLayer.strokeEnd = 1
      letterLayer.strokeColor = letterOutlineColour
      
      letterLayers.append(letterLayer)
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
    borderLayer.strokeColor = uiData.iconBorderColour.cgColor
    borderLayer.fillColor = UIColor.clear.cgColor
    
    layer.addSublayer(borderLayer)
    borderLayer.strokeStart = 0
    borderLayer.strokeEnd = 0
  }
  
  
  func displayTile() {
    borderLayer.strokeEnd = 1
    layer.backgroundColor = tileBackgroundColor
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
          animateStringLayerAppear(layer: lay, toOpacity: !inUse ? uiData.tileFadeOpacity : 1)
          lay.lineWidth = borderWidth
        }
      } else {
        for lay in letterLayers {
          lay.strokeEnd = 1
          lay.lineWidth = borderWidth
          lay.fillColor = tileFillColour
          if !inUse { lay.opacity = uiData.tileFadeOpacity }
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
  
  func fade(andUpdate: Bool) {
    inUse = false
    if andUpdate { for lay in letterLayers { lay.opacity = uiData.tileFadeOpacity } }
  }
  
  
  func unfade(andUpdate: Bool) {
    inUse = true
    if andUpdate { for lay in letterLayers { lay.opacity = 1 } }
  }
  
  
  func tileSelected() {
    for layer in letterLayers {
      layer.fillColor = tileSelectedColour
    }
      layer.borderColor = tileSelectedColour
  }
  
  
  func tileDeselected() {
    for layer in letterLayers {
      layer.fillColor = tileFillColour
    }
    layer.borderColor = uiData.iconBorderColour.cgColor
  }
  
  
  func animateStringLayerAppear(layer: CAShapeLayer, toOpacity: Float) {

      
      let end = CABasicAnimation(keyPath: "strokeEnd")
      end.fromValue = 0
      end.toValue = 1
      
      let fill = CABasicAnimation(keyPath: "opacity")
      fill.fromValue = 0
      fill.toValue = toOpacity
      
      let col = CABasicAnimation(keyPath: "fillColor")
      col.fromValue = UIColor.clear.cgColor
      col.toValue = tileFillColour
      
      CATransaction.begin()
      CATransaction.setAnimationDuration(tileAnimDuration)
      
      layer.add(end, forKey: end.keyPath)
      layer.add(fill, forKey: fill.keyPath)
      layer.add(col, forKey: col.keyPath)
      
      layer.strokeEnd = 1
      layer.opacity = toOpacity
      layer.fillColor = tileFillColour
      
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
    col.fromValue = tileFillColour
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
  
  
}
