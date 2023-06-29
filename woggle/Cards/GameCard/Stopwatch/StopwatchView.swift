//
//  StopwatchView.swift
//  woggle
//
//  Created by sparkes on 2023/06/25.
//

import UIKit

class StopwatchView: UIView {
  
  private let faceLayer = CAShapeLayer()
  private let secondsLayer = CAShapeLayer()
  
  private let centerFLoat: CGFloat
  private let lineWidth: CGFloat
  private let watchRadius: CGFloat
  
  private let secondsLength: CGFloat
  
  private var secondsAngle = Double.pi
  
  init(size s: CGFloat) {
    
    lineWidth = s * 0.05
    centerFLoat = s * 0.5
    watchRadius = s * 0.4
    secondsLength = (watchRadius * 0.9) - (lineWidth)
    
    super.init(frame: CGRect(x: 0, y: 0, width: s, height: s))
    
    layer.addSublayer(faceLayer)
    detailFaceLayer(fLayer: faceLayer)
    
    self.backgroundColor = UIColor.darkGray
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  

  
  func addSeconds() {
    drawSeconds(angle: secondsAngle)
  }
  
  func incrementSeconds(updateAngleIncrement: Double) {
    secondsAngle = (secondsAngle - updateAngleIncrement) //.truncatingRemainder(dividingBy: 2 * Double.pi)
//    // There's no need to truncate.
    secondsLayer.transform = CATransform3DMakeRotation(secondsAngle, 0.0, 0.0, 1.0)
  }
}


// MARK: Functions to modify layers
extension StopwatchView {
  
  
  func detailFaceLayer(fLayer: CAShapeLayer) {
    
    let facePath = UIBezierPath(
      arcCenter: CGPoint(x: centerFLoat, y: centerFLoat),
      radius: CGFloat(watchRadius - (lineWidth * 0.5)),
      startAngle: CGFloat(-(Double.pi / 2)),
      endAngle: CGFloat(3 * (Double.pi / 2)),
      clockwise: true)
    
    fLayer.path = facePath.cgPath
    fLayer.fillColor = UIColor.clear.cgColor
    fLayer.strokeColor = interactiveStrokeColour.cgColor
    fLayer.lineWidth = lineWidth
    fLayer.lineDashPattern = [NSNumber(value: (Double.pi * 2 * Double(watchRadius)/6)), NSNumber(value: Double(lineWidth)*2)]
    fLayer.lineCap = .round
  }
  
  
  func drawSeconds(angle: Double) {
    let secondsHand = UIBezierPath(roundedRect: CGRect(x: -0.5 * lineWidth, y: 0, width: lineWidth, height: secondsLength), cornerRadius: lineWidth * 0.5)
    secondsLayer.position = CGPoint(x: centerFLoat, y: centerFLoat)
    secondsLayer.transform = CATransform3DMakeRotation(secondsAngle, 0.0, 0.0, 1.0)

    secondsLayer.lineCap = .round
    secondsLayer.path = secondsHand.cgPath
    secondsLayer.fillColor = UIColor.darkGray.cgColor
    secondsLayer.strokeColor = UIColor.black.cgColor
    secondsLayer.lineWidth = 1
    
//    secondsLayer.transform = CATransform3DMakeRotation(Double.pi, 0.0, 0.0, 1.0)
    
    faceLayer.addSublayer(secondsLayer)
  }
  
}


//MARK: Functions to create layers
extension StopwatchView {
  
}


//MARK: Misc helper functions
extension StopwatchView {
  
}
