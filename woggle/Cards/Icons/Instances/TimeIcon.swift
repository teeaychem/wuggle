//
//  TimeIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit

class TimeIcon : IconView {
  
  private let faceColour: CGColor
  private let handColour: CGColor
  
  private let handStrokeWidth: CGFloat
  private let centerPoint: CGPoint
  
  private var handLayer: CAShapeLayer?
  
  
  init(viewData vD: UIData) {
    
    handStrokeWidth = CGFloat(vD.squareIconSize.height)/12
    centerPoint = CGPoint(x: vD.squareIconSize.width * 0.5, y: vD.squareIconSize.height * 0.5)
    faceColour = vD.colourM.cgColor
    handColour = vD.colourL.cgColor
    
    super.init(size: vD.squareIconSize, viewData: vD)
    
    addFace()
    addHand(angle: Double.pi/4)
  }
  
  
  override func updateIcon(value v: Int16) {
    // Division is 60 * 12 * 0.5.
    // 60 for minutes, 12 so each position is a minute. * 0.5 so Double.pi is functionally 2 * Double.pi
    if v > 0 {
      addHand(angle: (Double.pi * 0.5) - (Double.pi * (Double(v) / 360)))
    } else {
      // TODO: Inf case
    }
  }
  
  
  private func addFace() {
    let face = UIBezierPath(
      arcCenter: centerPoint,
      radius: size.width * 0.4,
      startAngle: CGFloat(0),
      endAngle:CGFloat(Double.pi * 2),
      clockwise: true)
    
    let faceLayer = CAShapeLayer()
    faceLayer.path = face.cgPath
    
    faceLayer.fillColor = faceColour
    faceLayer.strokeColor = viewData.iconBorderColour.cgColor
    faceLayer.lineWidth = 0.5
    
    layer.addSublayer(faceLayer)
    
  }
  
  private func addHand(angle a: Double) {
    let hand = UIBezierPath()
    hand.move(to: centerPoint)
    
    let handRadius = Double(size.height * 0.25)
    let handAngle = a
    
    let handEnd = CGPoint(x: Double(centerPoint.x) + handRadius * cos(handAngle) , y: Double(centerPoint.y) - handRadius * sin(handAngle))
    hand.addLine(to: handEnd)
    
    if handLayer != nil {
      handLayer?.removeFromSuperlayer()
      handLayer = nil
    }
    
    handLayer = CAShapeLayer()
    handLayer!.path = hand.cgPath
    handLayer!.strokeColor = handColour
    handLayer!.lineWidth = handStrokeWidth
    handLayer!.lineCap = .round
    
    layer.addSublayer(handLayer!)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

