//
//  TimeIcon.swift
//  buggle
//
//  Created by Benjamin Sparkes on 18/06/2019.
//  Copyright © 2019 Benjamin Sparkes. All rights reserved.
//

import UIKit

class TimeIcon : IconView {
  
  private let handWidth: CGFloat
  private let centerPoint: CGPoint
  
  private let faceLayer = CAShapeLayer()
  private let handLayer = CAShapeLayer()
  
  
  init(viewData vD: UIData) {
    
    handWidth = vD.squareIconSize.width * 0.1
    centerPoint = CGPoint(x: vD.squareIconSize.width * 0.5, y: vD.squareIconSize.height * 0.5)
    
    faceLayer.fillColor = vD.colourM.cgColor
    faceLayer.strokeColor = vD.iconBorderColour.cgColor
    faceLayer.lineWidth = 0.5
    
    handLayer.lineWidth = 0.25
    handLayer.strokeColor = UIColor.black.cgColor
    handLayer.fillColor = vD.colourL.cgColor
    
    super.init(size: vD.squareIconSize, viewData: vD)
    
    handLayer.position = centerPoint
    
    layer.addSublayer(faceLayer)
    layer.addSublayer(handLayer)
    
    setFacePath()
  }
  
  override func updateIcon(value v: Int16) {
      setHandPath(value: v)
  }
  
  
  private func setFacePath() {
    faceLayer.path = UIBezierPath(
      arcCenter: centerPoint,
      radius: size.width * 0.4,
      startAngle: CGFloat(0),
      endAngle:CGFloat(Double.pi * 2),
      clockwise: true).cgPath
  }
  
  
  private func setHandPath(value: Int16) {
    if value > 0 {
      handLayer.path = UIBezierPath(roundedRect:
                                      CGRect(origin: CGPoint(x: -0.5 * handWidth, y: 0),
                                             size: CGSize(width: handWidth, height: size.height * 0.36 - handWidth * 0.5)),
                                    cornerRadius: handWidth * 0.5).cgPath
      handLayer.transform = CATransform3DMakeRotation((Double.pi) + (Double.pi * (Double(value) / 360)), 0.0, 0.0, 1.0)
      // Division is 60 * 12 * 0.5.
      // 60 for minutes, 12 so each position is a minute. * 0.5 so Double.pi is functionally 2 * Double.pi
    } else {
      let handLength = (size.height * 0.36) - (handWidth * 0.5)
      // Follows the same size as stopWatch.
      handLayer.path = UIBezierPath(roundedRect:
                                      CGRect(origin: CGPoint(x: -0.5 * handWidth, y: -0.5  * handLength),
                                             size: CGSize(width: handWidth, height: handLength)),
                                    cornerRadius: handWidth * 0.5).cgPath
      handLayer.transform = CATransform3DMakeRotation(Double.pi * 0.5, 0.0, 0.0, 1.0)
    }

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

