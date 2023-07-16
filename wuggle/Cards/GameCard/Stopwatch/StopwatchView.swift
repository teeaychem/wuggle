//
//  StopwatchView.swift
//  wuggle
//
//  Created by sparkes on 2023/06/25.
//

import UIKit

class StopwatchView: UIView {
  
  private let secondsLayer = CAShapeLayer()
  let backgroundLayer = CAShapeLayer()
  let outerFaceLayer = CAShapeLayer()
  let innerFaceLayer = CAShapeLayer()
  
  private let watchSize: CGFloat
  private let indent: CGFloat
  private let centerFLoat: CGFloat
  private let lineWidth: CGFloat
  private let watchRadius: CGFloat
  private let cornerRadius: CGFloat
  
  private let secondsLength: CGFloat
  private var secondsAngle = Double.pi
  
  init(uiData uiD: UIData) {
    
    watchSize = uiD.stopWatchSize
    indent = uiD.tilePadding
    lineWidth = watchSize * 0.05
    centerFLoat = watchSize  * 0.5
    watchRadius = watchSize * 0.4
    secondsLength = (watchRadius * 0.9) - (lineWidth)
    cornerRadius = getCornerRadius(width: uiD.gameBoardSize)
    
    backgroundLayer.backgroundColor = uiD.colourL.cgColor
    backgroundLayer.cornerRadius = cornerRadius
    backgroundLayer.borderColor = uiD.iconBorderColour.cgColor
    backgroundLayer.borderWidth = 1

    outerFaceLayer.fillColor = uiD.colourM.cgColor
    outerFaceLayer.strokeColor = uiD.iconBorderColour.cgColor
    outerFaceLayer.lineWidth = 1
    
    innerFaceLayer.fillColor = uiD.colourL.cgColor
    innerFaceLayer.strokeColor = uiD.iconBorderColour.cgColor
    innerFaceLayer.lineWidth = 1
    
    secondsLayer.fillColor = uiD.colourM.cgColor
    secondsLayer.lineCap = .round
    secondsLayer.strokeColor = uiD.iconBorderColour.cgColor
    secondsLayer.lineWidth = 1
    secondsLayer.position = CGPoint(x: centerFLoat, y: centerFLoat)
    
    super.init(frame: CGRect(x: 0, y: 0, width: watchSize, height: watchSize))
    
    self.backgroundColor = uiD.colourD
    
    layer.addSublayer(backgroundLayer)
    layer.addSublayer(outerFaceLayer)
    layer.addSublayer(innerFaceLayer)
    layer.addSublayer(secondsLayer)
    
    paintWatchBackground()
    paintFaceLayer()
    makeSecondHandTo(angle: 0)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func makeSecondHandTo(angle: Double) {
    // if negative, then make for inf game.
    if (angle >= 0) {
      secondsLayer.path = UIBezierPath(roundedRect: CGRect(x: -0.5 * lineWidth, y: 0, width: lineWidth, height: secondsLength), cornerRadius: lineWidth * 0.5).cgPath
      secondsAngle = (Double.pi - angle) //.truncatingRemainder(dividingBy: 2 * Double.pi)
      //    // There's no need to truncate.
      secondsLayer.transform = CATransform3DMakeRotation(secondsAngle, 0.0, 0.0, 1.0)
    } else {
      // Rotating is animated, so to avoid dealing with this, draw the hand 'rotated'.
      secondsLayer.path = UIBezierPath(roundedRect: CGRect(x: -2.95 * lineWidth, y: lineWidth * -0.5, width: secondsLength, height: lineWidth), cornerRadius: lineWidth * 0.5).cgPath
//      -3 * linewidth as secondslength is indented this much. Then adjusted for width.
        // Likewise, y is shifted.
      secondsAngle = (Double.pi - angle)
      secondsLayer.transform = CATransform3DMakeRotation(secondsAngle, 0.0, 0.0, 1.0)
    }
  }
  
  
  func incrementSecondHand(toAngleIncrement: Double) {
    secondsAngle = (secondsAngle - toAngleIncrement)
    secondsLayer.transform = CATransform3DMakeRotation(secondsAngle, 0.0, 0.0, 1.0)
  }
}


// MARK: Functions to modify layers
extension StopwatchView {
  
  func paintWatchBackground() {
    let backgroundWidth = watchSize - (2 * indent)
    backgroundLayer.frame = CGRect(origin: CGPoint(x: indent, y: indent), size: CGSize(width: backgroundWidth, height: backgroundWidth))
  }
  
  
  func paintFaceLayer() {

    outerFaceLayer.path = UIBezierPath(
      arcCenter: CGPoint(x: centerFLoat, y: centerFLoat),
      radius: watchRadius,
      startAngle: CGFloat(-(Double.pi / 2)),
      endAngle: CGFloat(3 * (Double.pi / 2)),
      clockwise: true).cgPath
    
    innerFaceLayer.path = UIBezierPath(
      arcCenter: CGPoint(x: centerFLoat, y: centerFLoat),
      radius: watchRadius - lineWidth,
      startAngle: CGFloat(-(Double.pi / 2)),
      endAngle: CGFloat(3 * (Double.pi / 2)),
      clockwise: true).cgPath
  }
  
}
