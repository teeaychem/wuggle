//
//  StopwatchView.swift
//  woggle
//
//  Created by sparkes on 2023/06/25.
//

import UIKit

class StopwatchView: UIView {
  
  private let faceLayer = CAShapeLayer()
  
  private let centerCFLoat: CGFloat
  private let lineWidth: CGFloat
  private let watchRadius: CGFloat
  
  init(size s: CGFloat) {
    
    lineWidth = s * 0.05
    centerCFLoat = s * 0.5
    watchRadius = s * 0.4
    
    
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
  
}
