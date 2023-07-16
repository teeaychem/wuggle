//
//  PlayButtonsView.swift
//  woggle
//
//  Created by sparkes on 2023/06/28.
//

// This is a little funky.
// New game icon is animated and overwrite play and pause icons.
// However, animations don't stop as expected.
// So, new game icon is on a different layer to play and pause icons.
// Switching between these layers means play/pause icons are always static.
// New game is design to make a full spin.
// But, in some cases this may be exceeded.
// So, when switching between the layers, the new game icon rotation is reset.

import UIKit

class PlayButtonsView: UIView {
  
  // Some size/position constants
  private let buttonSize: CGSize
  private let xPadding: CGFloat
  private let subButtonWidth: CGFloat
  private let yPadding: CGFloat
  
  // Two subviews for playPause/Stop buttons
  let playPauseView: UIView
  
  private var playPauseLayer = CAShapeLayer()
  private var NewGameLayer = CAShapeLayer()
  
  let stopView: UIView
  
  private var stopLayer = CAShapeLayer()
  
  init(uiData uiD: UIData) {
    
    buttonSize = uiD.playPauseStopSize
    xPadding = uiD.gameBoardPadding * 0.5
    subButtonWidth = buttonSize.width - (xPadding * 2)
    yPadding = (buttonSize.height - (2 * (subButtonWidth))) / 3
    
    playPauseView = UIView(frame: CGRect(x: xPadding, y: yPadding, width: subButtonWidth, height: subButtonWidth))
    stopView = UIView(frame: CGRect(x: xPadding, y: (2 *  yPadding) + (subButtonWidth), width: subButtonWidth, height: subButtonWidth))
    playPauseView.layer.cornerRadius = getCornerRadius(width: uiD.cardSize.width)
    stopView.layer.cornerRadius = getCornerRadius(width: uiD.cardSize.width)
    
    
    stopLayer.strokeColor = uiD.iconBorderColour.cgColor
    stopLayer.lineWidth = 1
    stopLayer.fillColor = uiD.colourM.cgColor
    
    playPauseLayer.strokeColor = uiD.iconBorderColour.cgColor
    playPauseLayer.lineWidth = 1
    playPauseLayer.fillColor = uiD.colourM.cgColor
    
    NewGameLayer.strokeColor = uiD.iconBorderColour.cgColor
    NewGameLayer.lineWidth = 1
    NewGameLayer.fillColor = uiD.colourM.cgColor
    
    playPauseView.backgroundColor = uiD.colourL
    playPauseView.layer.borderColor = uiD.iconBorderColour.cgColor
    playPauseView.layer.borderWidth = 1
    
    stopView.backgroundColor = uiD.colourL
    stopView.layer.borderColor = uiD.iconBorderColour.cgColor
    stopView.layer.borderWidth = 1

    
    super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: buttonSize))
    
    addSubview(playPauseView)
    addSubview(stopView)
    
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func removeStopIcon() {
    stopView.layer.sublayers?.removeAll()
  }
  
  
  func removePlayPauseIcon() {
    playPauseView.layer.sublayers?.removeAll()
    NewGameLayer.transform = CATransform3DMakeRotation(2 * Double.pi, 0.0, 0.0, 1.0)
  }
  
  
  func makeStopIconPath(forView: UIView) -> CGPath {
    return UIBezierPath(
      roundedRect:
        CGRect(
          origin: CGPoint(x: forView.frame.width * 0.2, y: forView.frame.height * 0.2),
          size: CGSize(width: forView.frame.width * 0.6, height: forView.frame.height * 0.6)),
      cornerRadius: forView.layer.cornerRadius / 2)
    .cgPath
  }
  
  
  func addStopIcon() {
    stopLayer.path = makeStopIconPath(forView: stopView)
    stopView.layer.addSublayer(stopLayer)
  }
  
  
  func addPlayIcon() {
    playPauseLayer.path = makePlayIconPath(forView: playPauseView)
    playPauseLayer.frame = playPauseLayer.path!.boundingBox
    playPauseLayer.frame.origin = CGPoint(x: playPauseView.frame.width * 0.2, y: playPauseView.frame.height * 0.2)
    playPauseView.layer.addSublayer(playPauseLayer)
  }
  
  
  func addPauseIcon() {
    playPauseLayer.path = makePauseIconPath(forView: playPauseView)
    playPauseLayer.frame = playPauseLayer.path!.boundingBox
    playPauseLayer.frame.origin = CGPoint(x: playPauseView.frame.width * 0.2, y: playPauseView.frame.height * 0.2)
    playPauseView.layer.addSublayer(playPauseLayer)
  }
  
  
  func addNewGameIcon() {
    NewGameLayer.path = makeNewGameIconPath(forView: playPauseView)
    NewGameLayer.frame = NewGameLayer.path!.boundingBox
    NewGameLayer.frame.origin = CGPoint(x: playPauseView.frame.width * 0.2, y: playPauseView.frame.height * 0.2)
    playPauseView.layer.addSublayer(NewGameLayer)
  }
  
  
  func makePlayIconPath(forView: UIView) -> CGPath {
    // Basic idea, start in the top left.
    // Initial angle is pi.
    // Drawing an equalateral triangle, so each arc will be 2pi/3
    // Then, the next point is (r cos(angle), r sin(angle) offset by target point and radius.
    let iconCornerRadius = forView.layer.cornerRadius * 0.5
  
    let playIconPath = UIBezierPath()
    playIconPath.move(to: CGPoint(x: 0, y: iconCornerRadius))
    
    let angleIncrement = (2/3) * Double.pi
    
    playIconPath.addArc(
      withCenter: CGPoint(x: iconCornerRadius, y:  iconCornerRadius),
      radius: iconCornerRadius,
      startAngle: Double.pi,
      endAngle: Double.pi + angleIncrement,
      clockwise: true)
    playIconPath.addArc(
      withCenter: CGPoint(x: forView.frame.width * 0.6 - iconCornerRadius, y: forView.frame.height * 0.3),
      radius: iconCornerRadius,
      startAngle: Double.pi + angleIncrement,
      endAngle: Double.pi - angleIncrement,
      clockwise: true)
    playIconPath.addArc(
      withCenter: CGPoint(x: iconCornerRadius, y: forView.frame.height * 0.6 - iconCornerRadius),
      radius: iconCornerRadius,
      startAngle: Double.pi - angleIncrement,
      endAngle: Double.pi,
      clockwise: true)
    playIconPath.close()
    
    return playIconPath.cgPath
  }
  
  
  func rotatePlayPauseLayer(percent: Double) {
    NewGameLayer.transform = CATransform3DMakeRotation((percent * (2 * Double.pi)), 0.0, 0.0, 1.0)
  }
  
  
  func makePauseIconPath(forView: UIView) -> CGPath {
    
    let iconCornerRadius = forView.layer.cornerRadius * 0.5
    
    let pauseIconPath = CGMutablePath()
    let pauseSegmentWidth = forView.frame.width * 0.25
    
    let pauseIconLeft = UIBezierPath(
      roundedRect: CGRect(
          origin: CGPoint(x: 0, y: 0),
          size: CGSize(width: pauseSegmentWidth, height: forView.frame.height * 0.6)),
      cornerRadius: iconCornerRadius)
    let pauseIconRight = UIBezierPath(
      roundedRect: CGRect(
        origin: CGPoint(x: forView.frame.width * 0.35, y: 0),
        size: CGSize(width: pauseSegmentWidth, height: forView.frame.height * 0.6)),
      cornerRadius: iconCornerRadius)
    
    pauseIconPath.addPath(pauseIconLeft.cgPath)
    pauseIconPath.addPath(pauseIconRight.cgPath)
        
    return pauseIconPath
  }
  
  
  func makeNewGameIconPath(forView: UIView) -> CGPath {
    
    let iconCornerRadius = forView.layer.cornerRadius * 0.25
    let iconArcIndent = iconCornerRadius
    
    let newGameIconPath = UIBezierPath()
    newGameIconPath.move(to: CGPoint(x: iconCornerRadius, y: forView.frame.height * 0.3 + iconCornerRadius))
    newGameIconPath.addArc(withCenter: CGPoint(x: iconArcIndent, y: forView.frame.height * 0.3), radius: iconCornerRadius, startAngle: Double.pi * 0.5, endAngle: Double.pi * 1.5 , clockwise: true)
    newGameIconPath.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.3) - iconCornerRadius * 2, y: (forView.frame.height * 0.3) - iconCornerRadius * 2), radius: iconCornerRadius, startAngle: Double.pi * 0.5, endAngle: 0, clockwise: false)
    newGameIconPath.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.3), y: iconArcIndent), radius: iconCornerRadius, startAngle: Double.pi, endAngle: 0, clockwise: true)
    newGameIconPath.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.3 + iconCornerRadius * 2), y: (forView.frame.height * 0.3) - iconCornerRadius * 2), radius: iconCornerRadius, startAngle: Double.pi, endAngle: Double.pi * 0.5, clockwise: false)
    newGameIconPath.addArc(withCenter: CGPoint(x: forView.frame.width * 0.6 - iconArcIndent, y: forView.frame.height * 0.3), radius: iconCornerRadius, startAngle: Double.pi * -0.5, endAngle: Double.pi * 0.5 , clockwise: true)
    newGameIconPath.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.3 + iconCornerRadius * 2), y: (forView.frame.height * 0.3) + iconCornerRadius * 2), radius: iconCornerRadius, startAngle: Double.pi * -0.5, endAngle: -Double.pi, clockwise: false)
    newGameIconPath.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.3), y: forView.frame.height * 0.6 - iconArcIndent), radius: iconCornerRadius, startAngle: 0, endAngle: Double.pi, clockwise: true)
    newGameIconPath.addArc(withCenter: CGPoint(x: (forView.frame.width * 0.3 - iconCornerRadius * 2), y: (forView.frame.height * 0.3) + iconCornerRadius * 2), radius: iconCornerRadius, startAngle: 0, endAngle: Double.pi * -0.5, clockwise: false)
    newGameIconPath.close()
    
    
    return newGameIconPath.cgPath
  }
  
}
