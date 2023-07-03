//
//  StopwatchView.swift
//  woggle
//
//  Created by sparkes on 2023/06/25.
//

import UIKit

class StopwatchView: UIView {
  
//  private let faceLayer = CAShapeLayer()
  private let secondsLayer = CAShapeLayer()
  
  private let watchSize: CGFloat
  private let indent: CGFloat
  private let centerFLoat: CGFloat
  private let lineWidth: CGFloat
  private let watchRadius: CGFloat
  private let cornerRadius: CGFloat
  
  private let secondsLength: CGFloat
  
  private var secondsAngle = Double.pi
  
  init(viewData vD: CardViewData) {
    
    watchSize = vD.stopWatchSize()
    indent = vD.tilePadding()
    lineWidth = watchSize * 0.05
    centerFLoat = watchSize  * 0.5
    watchRadius = watchSize * 0.4
    secondsLength = (watchRadius * 0.9) - (lineWidth)
    cornerRadius = getCornerRadius(width: vD.gameBoardSize())
    
    super.init(frame: CGRect(x: 0, y: 0, width: watchSize, height: watchSize))
    
    self.backgroundColor = UIColor.darkGray
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  func addSeconds() {
    drawSeconds(angle: secondsAngle)
  }
  
  
  func resetSeconds() {
    secondsLayer.transform = CATransform3DMakeRotation(Double.pi, 0.0, 0.0, 1.0)
  }
  

  
  func incrementSeconds(updateAngleIncrement: Double) {
    secondsAngle = (secondsAngle - updateAngleIncrement) //.truncatingRemainder(dividingBy: 2 * Double.pi)
//    // There's no need to truncate.
    secondsLayer.transform = CATransform3DMakeRotation(secondsAngle, 0.0, 0.0, 1.0)
  }
}


// MARK: Functions to modify layers
extension StopwatchView {
  
  
  func paintWatchBackground() {
    let backgroundWidth = watchSize - (2 * indent)
    
    let highLightLayer = CAShapeLayer()
    highLightLayer.frame = CGRect(origin: CGPoint(x: indent, y: indent), size: CGSize(width: backgroundWidth, height: backgroundWidth))
    highLightLayer.backgroundColor = UIColor.lightGray.cgColor

    highLightLayer.cornerRadius = cornerRadius
    highLightLayer.borderColor = UIColor.black.cgColor
    highLightLayer.borderWidth = 1
    
    layer.addSublayer(highLightLayer)
  }
  
  
  func paintFaceLayer() {
    
    let outerFaceLayer = CAShapeLayer()
    
    let outerFacePath = UIBezierPath(
      arcCenter: CGPoint(x: centerFLoat, y: centerFLoat),
      radius: watchRadius,
      startAngle: CGFloat(-(Double.pi / 2)),
      endAngle: CGFloat(3 * (Double.pi / 2)),
      clockwise: true)
    
    outerFaceLayer.path = outerFacePath.cgPath
    outerFaceLayer.fillColor = UIColor.gray.cgColor
    outerFaceLayer.strokeColor = UIColor.black.cgColor
    outerFaceLayer.lineWidth = 1
    
    let innerFacePath = UIBezierPath(
      arcCenter: CGPoint(x: centerFLoat, y: centerFLoat),
      radius: watchRadius - lineWidth,
      startAngle: CGFloat(-(Double.pi / 2)),
      endAngle: CGFloat(3 * (Double.pi / 2)),
      clockwise: true)
    
    let innerFaceLayer = CAShapeLayer()
    
    innerFaceLayer.path = innerFacePath.cgPath
    innerFaceLayer.fillColor = UIColor.lightGray.cgColor
    innerFaceLayer.strokeColor = UIColor.black.cgColor
    innerFaceLayer.lineWidth = 1
    
    layer.addSublayer(outerFaceLayer)
    layer.addSublayer(innerFaceLayer)
  }
  
  
  func drawSeconds(angle: Double) {
    let secondsHand = UIBezierPath(roundedRect: CGRect(x: -0.5 * lineWidth, y: 0, width: lineWidth, height: secondsLength), cornerRadius: lineWidth * 0.5)
    secondsLayer.position = CGPoint(x: centerFLoat, y: centerFLoat)
    secondsLayer.transform = CATransform3DMakeRotation(secondsAngle, 0.0, 0.0, 1.0)

    secondsLayer.lineCap = .round
    secondsLayer.path = secondsHand.cgPath
    secondsLayer.fillColor = UIColor.gray.cgColor
    secondsLayer.strokeColor = UIColor.black.cgColor
    secondsLayer.lineWidth = 1
    
    layer.addSublayer(secondsLayer)
  }
  
}


//MARK: Functions to create layers
extension StopwatchView {
  
}


//MARK: Misc helper functions
extension StopwatchView {
  
}
