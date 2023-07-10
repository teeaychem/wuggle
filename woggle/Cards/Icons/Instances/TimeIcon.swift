//
//  TimeIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit

class TimeIcon : IconView {
  
  
  let faceColour = UIColor.gray.cgColor
  let handColour = UIColor.lightGray.cgColor
  
  let handStrokeWidth: CGFloat
  let centerPoint: CGPoint
  
  var handLayer: CAShapeLayer?
  
  
  override init(size s: CGSize) {
    
    handStrokeWidth = CGFloat(s.height)/12
    centerPoint = CGPoint(x: s.width * 0.5, y: s.height * 0.5)
    
    super.init(size: s)
    
    addFace()
    addHand(angle: Double.pi/4)
  }
  
  
  override func updateIcon(value v: String) {
    
    let valPercent = (Double(v) ?? 0)/12
    let radians = (Double.pi * 0.5) - (2 * Double.pi * valPercent)
    
    addHand(angle: radians)
  }
  
  
  private func addFace() {
    let face = UIBezierPath(arcCenter: centerPoint, radius: size.width * 0.4, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
    
    let faceLayer = CAShapeLayer()
    faceLayer.path = face.cgPath
    
    faceLayer.fillColor = faceColour
    faceLayer.strokeColor = UIColor.black.cgColor
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

