//
//  PlayButtonsView.swift
//  woggle
//
//  Created by sparkes on 2023/06/28.
//

import UIKit

class PlayButtonsView: UIView {
  
  let playLayer = CAShapeLayer()
  let stopLayer = CAShapeLayer()
  
  init(size: CGSize) {
    
    // This is changing the frame to which the shape layer belongs.
    // This isn't setting up a frame from the layer.
    // I think. And, this is unrelated to the frame of the viewcontroller.
    // So, doing this doesn't affect anything.
    playLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.width)
//    stopLayer.frame = CGRect(origin: CGPoint(x: 0,y: size.width), size: CGSize(width: size.width, height: size.height/2))
    
    
    super.init(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: size))
    
    layer.addSublayer(playLayer)
//    layer.addSublayer(stopLayer)
    playLayer.backgroundColor = UIColor.red.cgColor
//    stopLayer.backgroundColor = UIColor.blue.cgColor
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func AddStopIcon () {
    
    let secondsHand = UIBezierPath()
    secondsHand.move(to: CGPoint(x: 0, y: 0))
    secondsHand.addLine(to: CGPoint(x: playLayer.frame.maxX, y: playLayer.frame.maxY))
    playLayer.lineCap = .round
    playLayer.path = secondsHand.cgPath
    playLayer.strokeColor = interactiveStrokeColour.cgColor
    playLayer.lineWidth = 5
    
//    stopLayer.addSublayer(secondsLayer)
    
  }
  
}
