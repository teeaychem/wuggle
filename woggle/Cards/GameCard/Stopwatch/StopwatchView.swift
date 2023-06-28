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
  
  private let centerCFLoat: CGFloat
  private let lineWidth: CGFloat
  private let watchRadius: CGFloat
  
  private let secondsLength: CGFloat
  
  private var secondsAngle = Double(0.75 * 2 * Double.pi)
  
  init(size s: CGFloat) {
    
    lineWidth = s * 0.05
    centerCFLoat = s * 0.5
    watchRadius = s * 0.4
    secondsLength = (watchRadius * 0.9) - (2 * lineWidth)
    
    super.init(frame: CGRect(x: 0, y: 0, width: s, height: s))
    
    layer.addSublayer(faceLayer)
    detailFaceLayer(fLayer: faceLayer)
    
    self.backgroundColor = UIColor.darkGray
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func detailFaceLayer(fLayer: CAShapeLayer) {
    
    let facePath = UIBezierPath(
      arcCenter: CGPoint(x: centerCFLoat, y: centerCFLoat),
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
    let secondsHand = UIBezierPath()
    secondsHand.move(to: CGPoint(x: centerCFLoat, y: centerCFLoat))
    secondsHand.addLine(to: CGPoint(x: centerCFLoat + (secondsLength * CGFloat(cos(angle))),
                                    y: centerCFLoat + (secondsLength * CGFloat(sin(angle)))
    ))
    secondsLayer.lineCap = .round
    secondsLayer.path = secondsHand.cgPath
    secondsLayer.strokeColor = interactiveStrokeColour.cgColor
    secondsLayer.lineWidth = lineWidth
    
    layer.addSublayer(secondsLayer)
  }
  
  
  func addSeconds() {
    drawSeconds(angle: secondsAngle)
  }
  
  func incrementSeconds(updateAngleIncrement: Double) {
    secondsAngle = (secondsAngle + updateAngleIncrement) //.truncatingRemainder(dividingBy: 2 * Double.pi)
    // There's no need to truncate.
    drawSeconds(angle: secondsAngle)
  }
}
